Return-Path: <io-uring+bounces-13472-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +I/9FYUfDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13472-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:54:29 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FAC59A496
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 024D2306DD2C
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABF0377555;
	Wed, 20 May 2026 20:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eki62Gi6"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F9E376497
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310250; cv=none; b=Ra1+pXxR9kbrVz5ANfxFs8sZ+/aKx+DofdOLSX2nxNUKoR9VvhnGK76frSBO3rayimBSW/LtVPMsS5bNhvKzcSizh8dK1xuakm6xa8BEEpjwTS2f5YzWck+8WwfT76Suy0iaAq6NmLEtOCqe2msSFp9AW8BOqXmpoYVtKKhT/Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310250; c=relaxed/simple;
	bh=yTsT4MTanmPV7BjuSqLOqTfpIoxcx3ADCk+oaTv3+ZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HQhqQoJ7iJQxMvXGftpMHRSqQuDos8h1pcFsdW/fpEMY7T61zuY7Y6GgiLQJ3sxrkTFwWC0tkiLfkz7jHqD656o5SJG9yM4e6o3sI3iQTBaCO8ugGdfPpGhaZFeNaSGBUWlNnMjWzyXM1uXGh5rRBovO5RFmQxRSy/GfwlFgGcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eki62Gi6; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO0Sw1270743
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5DYC
	zqTKbvdRmrDK6yQ7IbYekrJTixKptsXZVS++o38=; b=eki62Gi6Oexp6jbg0mKB
	+gAM4I9jH4VaSKpxJCUTq5VOpozJJuJEmsBIs1ldLyi+yLxf5Hej4VGO/Rm79ogi
	+lGM7nZwTZcEhSVlPH2b4j3DW2XQtVlZfxaTMqHe6HX0R9B33UVKI6Ch9WH/aaUQ
	/Nd3NrjeKxAgNv3LXFUeLq0RsN+M892JUxkAFcLGaekU5fNmOrLgfABzJSJayjI2
	8vIGmYeIiKBMNyBP4XlLsOzqAS8j5rDWnVmWRqLyThLZQfOzij6SEXn8H7XtLOvL
	g8s4FquNdM6Pizj4XVpgHW8jUFG0aEz+cTOq8E2xflA4i5agkq7SX0iQbwF0R+pi
	Mw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e98j6wc97-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90d7b3406b2so1288421185a.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310244; x=1779915044;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5DYCzqTKbvdRmrDK6yQ7IbYekrJTixKptsXZVS++o38=;
        b=L9rEFo48hDP1rP1bHicjirIBZeoghoUOXXEWigpLTq2hTg4AB7oKXRSGDcqft6DoL6
         Qoo/7BP2wvcJYq7GBE1M/yGLdVUJmxObj3cUStldMt1hZ8Ij1+SnHjCZj6+funvVcm/b
         73ezE31iMXQc1x/AUklPe+nzCgazOaEfauGgorMfeaKr+fl4LB3Pf9IyKhHuFPvOqqC4
         1iMk/81fkm9CdZQXkBLK3o+kT8kP6etgayrree3ik0zBos8rhZBOPIfqtJIrKqDKPI4W
         Vi/4zMNLNVvFJT35QxQ51f8DZjBZcZfxWKNdv4/6U6ZjsDuKpPjxwkGtsnR8AGSETGgU
         BiMA==
X-Forwarded-Encrypted: i=1; AFNElJ8KGxeZTHZ5K3AoX8rhyU4xbPBC2vr0J0twAh2kT9sEkkOyjUhyZvhsh4VGPPsOXX0LkDyeQ7/utQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9PShm41SKvpiNe7cX3XdOIiJuSlmM8EEXF2iw/0NwnlilSOax
	80c1rfaCTmuWus1kdTaK4RTUNYVcawUuMS8zlLrW8lM3WOL0DNY6P7PaoSU8ZhdbFkXcJ64OBVS
	sjzflsD3zg8uWQoHUflP0BsRRrTXbzCxhL2jwuhCcMB+Ht0Ipui4cY0hT
X-Gm-Gg: Acq92OHpK7kEqyTWsyJA1pcCfUGWPE+2SqFHcyeTg8vu/dx5FCrPSPUya4bAk4hIyUS
	FSCPyzc85nf8iRApSxzQlQ+M8cqojuAAY95k9X0Tl1TTM41+b4RUNDRZsBU1kyN+OETPdsKWq3J
	zz3ilJ9LSgol3j9RN/6pLWxSsmWHfVF2UwY0sgHrd8vlR01kWf++CFH/QY9AC4stSbt4gvoBCUX
	aI//f9JFm/atLw0C9koEg84IIeQwIXgqdj55YKkjomKt3yNUfL8bFF8wiVV8tGBnzuXtE2EWuit
	5QHAAXDpLeYIlH8xw6UFxBa4ppMsUb0RsxzZ+uAStlUj4OwSilxu1fBDnODN+eoURd6ZEpY+2PR
	6nqbRq9xWE7g3z1Xe/Qomrdh9ezJ7R/SszX+bCqN5Wh4oLxr1ewRoBxZ7Psz+X+ornD5sAkrzLM
	IVGw==
X-Received: by 2002:a05:620a:468f:b0:8cd:b70b:fd00 with SMTP id af79cd13be357-911ce330dd6mr4090124585a.16.1779310243982;
        Wed, 20 May 2026 13:50:43 -0700 (PDT)
X-Received: by 2002:a05:620a:468f:b0:8cd:b70b:fd00 with SMTP id af79cd13be357-911ce330dd6mr4090119085a.16.1779310243267;
        Wed, 20 May 2026 13:50:43 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:02 -0400
Subject: [PATCH RFC 11/11] fs: move generic_file_write_iter() family to
 fs/read_write.c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-11-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=21055;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yTsT4MTanmPV7BjuSqLOqTfpIoxcx3ADCk+oaTv3+ZQ=;
 b=pnZtz23UD0UmzGK1JF55M8gJyFr39Fbr88g9tveN1RrBZttxjf03za+ECw+z8h1q8W3XU4Gc6
 mLEEtbgMzn2CtlWhj/fgZUlRAzRNrQvC3nKL7GTyYq12T29/MeCqrNo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX8rLRAtFUfzqd
 Ltbs0tBcDjcu6azrPT8dNkO/YdWO2ezTo6xCGrICFMGGs8MZhtxe85HQxRyhr1JbUelzmFeYj/a
 xDe2zSK1j//k/+iqHm9S+tcR+eA8+SUdT0curB3e1Vfn70KjPAp+46QIPWc4s8cdqp9OSEAr5mi
 2umDrV2VvnJXDLlp6hbTbmL6dXQ0bmPid619MMi/SpUzPBxMH0AmAFyqOLUWGtk2134IwU9chcP
 hlnIQglO1AyPwnCrA0M8k4z+wSpcNtjaWFRrZwzcPkRcRxIXuz5nTHUmghlzLUT+BQ9/DGvZJWb
 EWeVcqxTxpDi1/ZadzA7N9TWOFTEoxUD5Ep5aPKEYDFOFjLZ1675VGEDSI3DHd6HepsF15kbG44
 0owQGZMeh/pxJwBqAHVpcMZxILFnLuOhd/wpqC6ba4vk/5Lz5nqJoUk8vMfAx0Znx+aHyzT48o+
 TTUpYXs+qaTV/8Sz2sw==
X-Authority-Analysis: v=2.4 cv=TsDWQjXh c=1 sm=1 tr=0 ts=6a0e1ea4 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=t4iOdaPQC35MTOVVYvEA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: hwmcuctpZa2nCyAY3_zFJ6QCJD9dksD_
X-Proofpoint-ORIG-GUID: hwmcuctpZa2nCyAY3_zFJ6QCJD9dksD_
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 phishscore=0 lowpriorityscore=10 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13472-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,columbia.edu:email,columbia.edu:mid,columbia.edu:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 10FAC59A496
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move the VFS-level generic write path out of mm/filemap.c into
fs/read_write.c next to the just-relocated read path:

  - generic_file_write_iter()
  - __generic_file_write_iter()
  - generic_file_direct_write()
  - generic_perform_write()
  - kiocb_invalidate_pages()
  - kiocb_invalidate_post_direct_write()
  - dio_warn_stale_pagecache()

The kiocb_invalidate_* prototypes move from <linux/pagemap.h> to
<linux/fs.h>, joining kiocb_write_and_wait() and the other generic
read/write declarations. Drop extern from the prototypes of all
five generic_file_* declarations in <linux/fs.h>. Reflow the
generic_file_direct_write() definition to fit on one line.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/read_write.c         | 276 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |   8 +-
 include/linux/pagemap.h |   2 -
 mm/filemap.c            | 277 ------------------------------------------------
 4 files changed, 281 insertions(+), 282 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 59ceea85c163..cea5f79fdacf 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1071,6 +1071,282 @@ ssize_t generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	return filemap_invalidate_pages(mapping, iocb->ki_pos,
+					iocb->ki_pos + count - 1,
+					iocb->ki_flags & IOCB_NOWAIT);
+}
+EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
+
+/*
+ * Warn about a page cache invalidation failure during a direct I/O write.
+ */
+static void dio_warn_stale_pagecache(struct file *filp)
+{
+	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
+	char pathname[128];
+	char *path;
+
+	errseq_set(&filp->f_mapping->wb_err, -EIO);
+	if (__ratelimit(&_rs)) {
+		path = file_path(filp, pathname, sizeof(pathname));
+		if (IS_ERR(path))
+			path = "(unknown)";
+		pr_crit("Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!\n");
+		pr_crit("File: %s PID: %d Comm: %.20s\n", path, current->pid,
+			current->comm);
+	}
+}
+
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	if (mapping->nrpages &&
+	    invalidate_inode_pages2_range(mapping,
+			iocb->ki_pos >> PAGE_SHIFT,
+			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
+		dio_warn_stale_pagecache(iocb->ki_filp);
+}
+
+ssize_t generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	size_t write_len = iov_iter_count(from);
+	ssize_t written;
+
+	/*
+	 * If a page can not be invalidated, return 0 to fall back
+	 * to buffered write.
+	 */
+	written = kiocb_invalidate_pages(iocb, write_len);
+	if (written) {
+		if (written == -EBUSY)
+			return 0;
+		return written;
+	}
+
+	written = mapping->a_ops->direct_IO(iocb, from);
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * cached by non-direct readahead, or faulted in by get_user_pages()
+	 * if the source of the write was an mmap'ed region of the file
+	 * we're writing.  Either one is a pretty crazy thing to do,
+	 * so we don't support it 100%.  If this invalidation
+	 * fails, tough, the write still worked...
+	 *
+	 * Most of the time we do not need this since dio_complete() will do
+	 * the invalidation for us. However there are some file systems that
+	 * do not end up with dio_complete() being called, so let's not break
+	 * them by removing it completely.
+	 *
+	 * Noticeable example is a blkdev_direct_IO().
+	 *
+	 * Skip invalidation for async writes or if mapping has no pages.
+	 */
+	if (written > 0) {
+		struct inode *inode = mapping->host;
+		loff_t pos = iocb->ki_pos;
+
+		kiocb_invalidate_post_direct_write(iocb, written);
+		pos += written;
+		write_len -= written;
+		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
+			i_size_write(inode, pos);
+			mark_inode_dirty(inode);
+		}
+		iocb->ki_pos = pos;
+	}
+	if (written != -EIOCBQUEUED)
+		iov_iter_revert(from, write_len - iov_iter_count(from));
+	return written;
+}
+EXPORT_SYMBOL(generic_file_direct_write);
+
+ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
+{
+	struct file *file = iocb->ki_filp;
+	loff_t pos = iocb->ki_pos;
+	struct address_space *mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	size_t chunk = mapping_max_folio_size(mapping);
+	long status = 0;
+	ssize_t written = 0;
+
+	do {
+		struct folio *folio;
+		size_t offset;		/* Offset into folio */
+		size_t bytes;		/* Bytes to write to folio */
+		size_t copied;		/* Bytes copied from user */
+		void *fsdata = NULL;
+
+		bytes = iov_iter_count(i);
+retry:
+		offset = pos & (chunk - 1);
+		bytes = min(chunk - offset, bytes);
+		balance_dirty_pages_ratelimited(mapping);
+
+		if (fatal_signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
+
+		status = a_ops->write_begin(iocb, mapping, pos, bytes,
+						&folio, &fsdata);
+		if (unlikely(status < 0))
+			break;
+
+		offset = offset_in_folio(folio, pos);
+		if (bytes > folio_size(folio) - offset)
+			bytes = folio_size(folio) - offset;
+
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_folio(folio);
+
+		/*
+		 * Faults here on mmap()s can recurse into arbitrary
+		 * filesystem code. Lots of locks are held that can
+		 * deadlock. Use an atomic copy to avoid deadlocking
+		 * in page fault handling.
+		 */
+		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
+		flush_dcache_folio(folio);
+
+		status = a_ops->write_end(iocb, mapping, pos, bytes, copied,
+						folio, fsdata);
+		if (unlikely(status != copied)) {
+			iov_iter_revert(i, copied - max(status, 0L));
+			if (unlikely(status < 0))
+				break;
+		}
+		cond_resched();
+
+		if (unlikely(status == 0)) {
+			/*
+			 * A short copy made ->write_end() reject the
+			 * thing entirely.  Might be memory poisoning
+			 * halfway through, might be a race with munmap,
+			 * might be severe memory pressure.
+			 */
+			if (chunk > PAGE_SIZE)
+				chunk /= 2;
+			if (copied) {
+				bytes = copied;
+				goto retry;
+			}
+
+			/*
+			 * 'folio' is now unlocked and faults on it can be
+			 * handled. Ensure forward progress by trying to
+			 * fault it in now.
+			 */
+			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
+				status = -EFAULT;
+				break;
+			}
+		} else {
+			pos += status;
+			written += status;
+		}
+	} while (iov_iter_count(i));
+
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
+}
+EXPORT_SYMBOL(generic_perform_write);
+
+/**
+ * __generic_file_write_iter - write data to a file
+ * @iocb:	IO state structure (file, offset, etc.)
+ * @from:	iov_iter with data to write
+ *
+ * This function does all the work needed for actually writing data to a
+ * file. It does all basic checks, removes SUID from the file, updates
+ * modification times and calls proper subroutines depending on whether we
+ * do direct IO or a standard buffered write.
+ *
+ * It expects i_rwsem to be grabbed unless we work on a block device or similar
+ * object which does not need locking at all.
+ *
+ * This function does *not* take care of syncing data in case of O_SYNC write.
+ * A caller has to handle it. This is mainly due to the fact that we want to
+ * avoid syncing under i_rwsem.
+ *
+ * Return:
+ * * number of bytes written, even for truncated writes
+ * * negative error code if no data has been written at all
+ */
+ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	ssize_t ret;
+
+	ret = file_remove_privs(file);
+	if (ret)
+		return ret;
+
+	ret = file_update_time(file);
+	if (ret)
+		return ret;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		ret = generic_file_direct_write(iocb, from);
+		/*
+		 * If the write stopped short of completing, fall back to
+		 * buffered writes.  Some filesystems do this for writes to
+		 * holes, for example.  For DAX files, a buffered write will
+		 * not succeed (even if it did, DAX does not handle dirty
+		 * page-cache pages correctly).
+		 */
+		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
+			return ret;
+		return direct_write_fallback(iocb, from, ret,
+				generic_perform_write(iocb, from));
+	}
+
+	return generic_perform_write(iocb, from);
+}
+EXPORT_SYMBOL(__generic_file_write_iter);
+
+/**
+ * generic_file_write_iter - write data to a file
+ * @iocb:	IO state structure
+ * @from:	iov_iter with data to write
+ *
+ * This is a wrapper around __generic_file_write_iter() to be used by most
+ * filesystems. It takes care of syncing the file in case of O_SYNC file
+ * and acquires i_rwsem as needed.
+ * Return:
+ * * negative error code if no data has been written at all of
+ *   vfs_fsync_range() failed for a synchronous write
+ * * number of bytes written, even for truncated writes
+ */
+ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret > 0)
+		ret = __generic_file_write_iter(iocb, from);
+	inode_unlock(inode);
+
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	return ret;
+}
+EXPORT_SYMBOL(generic_file_write_iter);
+
 static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 			 unsigned long vlen, loff_t *pos, rwf_t flags)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c0151ced8e7a..6cfb9e46bc37 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3057,9 +3057,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
 		ssize_t already_read);
 ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
-extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
+ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 ssize_t generic_perform_write(struct kiocb *, struct iov_iter *);
 ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
 		ssize_t direct_written, ssize_t buffered_written);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 46cefd552a51..b7c2dc8076ab 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -31,8 +31,6 @@ static inline void invalidate_remote_inode(struct inode *inode)
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
-int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
-void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index db7c53cd681b..284c0296a011 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2276,17 +2276,6 @@ int filemap_invalidate_pages(struct address_space *mapping,
 					     end >> PAGE_SHIFT);
 }
 
-int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-	return filemap_invalidate_pages(mapping, iocb->ki_pos,
-					iocb->ki_pos + count - 1,
-					iocb->ki_flags & IOCB_NOWAIT);
-}
-EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
-
-
 /*
  * Splice subpages from a folio into a pipe.
  */
@@ -3500,272 +3489,6 @@ struct page *read_cache_page_gfp(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page_gfp);
 
-/*
- * Warn about a page cache invalidation failure during a direct I/O write.
- */
-static void dio_warn_stale_pagecache(struct file *filp)
-{
-	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
-	char pathname[128];
-	char *path;
-
-	errseq_set(&filp->f_mapping->wb_err, -EIO);
-	if (__ratelimit(&_rs)) {
-		path = file_path(filp, pathname, sizeof(pathname));
-		if (IS_ERR(path))
-			path = "(unknown)";
-		pr_crit("Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!\n");
-		pr_crit("File: %s PID: %d Comm: %.20s\n", path, current->pid,
-			current->comm);
-	}
-}
-
-void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-	if (mapping->nrpages &&
-	    invalidate_inode_pages2_range(mapping,
-			iocb->ki_pos >> PAGE_SHIFT,
-			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
-		dio_warn_stale_pagecache(iocb->ki_filp);
-}
-
-ssize_t
-generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	size_t write_len = iov_iter_count(from);
-	ssize_t written;
-
-	/*
-	 * If a page can not be invalidated, return 0 to fall back
-	 * to buffered write.
-	 */
-	written = kiocb_invalidate_pages(iocb, write_len);
-	if (written) {
-		if (written == -EBUSY)
-			return 0;
-		return written;
-	}
-
-	written = mapping->a_ops->direct_IO(iocb, from);
-
-	/*
-	 * Finally, try again to invalidate clean pages which might have been
-	 * cached by non-direct readahead, or faulted in by get_user_pages()
-	 * if the source of the write was an mmap'ed region of the file
-	 * we're writing.  Either one is a pretty crazy thing to do,
-	 * so we don't support it 100%.  If this invalidation
-	 * fails, tough, the write still worked...
-	 *
-	 * Most of the time we do not need this since dio_complete() will do
-	 * the invalidation for us. However there are some file systems that
-	 * do not end up with dio_complete() being called, so let's not break
-	 * them by removing it completely.
-	 *
-	 * Noticeable example is a blkdev_direct_IO().
-	 *
-	 * Skip invalidation for async writes or if mapping has no pages.
-	 */
-	if (written > 0) {
-		struct inode *inode = mapping->host;
-		loff_t pos = iocb->ki_pos;
-
-		kiocb_invalidate_post_direct_write(iocb, written);
-		pos += written;
-		write_len -= written;
-		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
-			i_size_write(inode, pos);
-			mark_inode_dirty(inode);
-		}
-		iocb->ki_pos = pos;
-	}
-	if (written != -EIOCBQUEUED)
-		iov_iter_revert(from, write_len - iov_iter_count(from));
-	return written;
-}
-EXPORT_SYMBOL(generic_file_direct_write);
-
-ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
-{
-	struct file *file = iocb->ki_filp;
-	loff_t pos = iocb->ki_pos;
-	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	size_t chunk = mapping_max_folio_size(mapping);
-	long status = 0;
-	ssize_t written = 0;
-
-	do {
-		struct folio *folio;
-		size_t offset;		/* Offset into folio */
-		size_t bytes;		/* Bytes to write to folio */
-		size_t copied;		/* Bytes copied from user */
-		void *fsdata = NULL;
-
-		bytes = iov_iter_count(i);
-retry:
-		offset = pos & (chunk - 1);
-		bytes = min(chunk - offset, bytes);
-		balance_dirty_pages_ratelimited(mapping);
-
-		if (fatal_signal_pending(current)) {
-			status = -EINTR;
-			break;
-		}
-
-		status = a_ops->write_begin(iocb, mapping, pos, bytes,
-						&folio, &fsdata);
-		if (unlikely(status < 0))
-			break;
-
-		offset = offset_in_folio(folio, pos);
-		if (bytes > folio_size(folio) - offset)
-			bytes = folio_size(folio) - offset;
-
-		if (mapping_writably_mapped(mapping))
-			flush_dcache_folio(folio);
-
-		/*
-		 * Faults here on mmap()s can recurse into arbitrary
-		 * filesystem code. Lots of locks are held that can
-		 * deadlock. Use an atomic copy to avoid deadlocking
-		 * in page fault handling.
-		 */
-		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
-		flush_dcache_folio(folio);
-
-		status = a_ops->write_end(iocb, mapping, pos, bytes, copied,
-						folio, fsdata);
-		if (unlikely(status != copied)) {
-			iov_iter_revert(i, copied - max(status, 0L));
-			if (unlikely(status < 0))
-				break;
-		}
-		cond_resched();
-
-		if (unlikely(status == 0)) {
-			/*
-			 * A short copy made ->write_end() reject the
-			 * thing entirely.  Might be memory poisoning
-			 * halfway through, might be a race with munmap,
-			 * might be severe memory pressure.
-			 */
-			if (chunk > PAGE_SIZE)
-				chunk /= 2;
-			if (copied) {
-				bytes = copied;
-				goto retry;
-			}
-
-			/*
-			 * 'folio' is now unlocked and faults on it can be
-			 * handled. Ensure forward progress by trying to
-			 * fault it in now.
-			 */
-			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
-				status = -EFAULT;
-				break;
-			}
-		} else {
-			pos += status;
-			written += status;
-		}
-	} while (iov_iter_count(i));
-
-	if (!written)
-		return status;
-	iocb->ki_pos += written;
-	return written;
-}
-EXPORT_SYMBOL(generic_perform_write);
-
-/**
- * __generic_file_write_iter - write data to a file
- * @iocb:	IO state structure (file, offset, etc.)
- * @from:	iov_iter with data to write
- *
- * This function does all the work needed for actually writing data to a
- * file. It does all basic checks, removes SUID from the file, updates
- * modification times and calls proper subroutines depending on whether we
- * do direct IO or a standard buffered write.
- *
- * It expects i_rwsem to be grabbed unless we work on a block device or similar
- * object which does not need locking at all.
- *
- * This function does *not* take care of syncing data in case of O_SYNC write.
- * A caller has to handle it. This is mainly due to the fact that we want to
- * avoid syncing under i_rwsem.
- *
- * Return:
- * * number of bytes written, even for truncated writes
- * * negative error code if no data has been written at all
- */
-ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	ssize_t ret;
-
-	ret = file_remove_privs(file);
-	if (ret)
-		return ret;
-
-	ret = file_update_time(file);
-	if (ret)
-		return ret;
-
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		ret = generic_file_direct_write(iocb, from);
-		/*
-		 * If the write stopped short of completing, fall back to
-		 * buffered writes.  Some filesystems do this for writes to
-		 * holes, for example.  For DAX files, a buffered write will
-		 * not succeed (even if it did, DAX does not handle dirty
-		 * page-cache pages correctly).
-		 */
-		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
-			return ret;
-		return direct_write_fallback(iocb, from, ret,
-				generic_perform_write(iocb, from));
-	}
-
-	return generic_perform_write(iocb, from);
-}
-EXPORT_SYMBOL(__generic_file_write_iter);
-
-/**
- * generic_file_write_iter - write data to a file
- * @iocb:	IO state structure
- * @from:	iov_iter with data to write
- *
- * This is a wrapper around __generic_file_write_iter() to be used by most
- * filesystems. It takes care of syncing the file in case of O_SYNC file
- * and acquires i_rwsem as needed.
- * Return:
- * * negative error code if no data has been written at all of
- *   vfs_fsync_range() failed for a synchronous write
- * * number of bytes written, even for truncated writes
- */
-ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	ssize_t ret;
-
-	inode_lock(inode);
-	ret = generic_write_checks(iocb, from);
-	if (ret > 0)
-		ret = __generic_file_write_iter(iocb, from);
-	inode_unlock(inode);
-
-	if (ret > 0)
-		ret = generic_write_sync(iocb, ret);
-	return ret;
-}
-EXPORT_SYMBOL(generic_file_write_iter);
 
 /**
  * filemap_release_folio() - Release fs-specific metadata on a folio.

-- 
2.39.5


