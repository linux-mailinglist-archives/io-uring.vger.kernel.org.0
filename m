Return-Path: <io-uring+bounces-13470-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KsTG1AfDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13470-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:53:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09AF859A433
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E77A43067CD3
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6B3378839;
	Wed, 20 May 2026 20:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="RaMC69iL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323603783B4
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310248; cv=none; b=lxybQCG03pPo/kZr8N6NoFnp1B1haBGfatu2bQ5Lnc3LhrcZXxG7ftTtlXombk+CSkXMMfQshLHj+ci6VPcmRCN1RXTfIApc9LLmHh+Af8wa74HpfDrX5N2mPsfic2xkARJvCasDXyiKbQNr0yRyTSkTR7HfaomPeAX2Bw5y0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310248; c=relaxed/simple;
	bh=sWXCb2voUNh/5RgXFZA32Pq1QXHhhJuRnYDZVKm8gu0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ak9Rh5xZwl4n+iIzQMCdEOj3y4RUkb7Ir18ojVfafLbP+1cUTz11FgEfn0v5cb+2dkhYkfS+/LOqN8AAMtkVSDS3g14mmLHs6f0asbYg0VWZXvC4h+VXvDLJ6fpWlL4ivwPmdEz3TrN2SYoKmDb2ylM/RupN8y2lIb28r12d3sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=RaMC69iL; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOCBq2145196
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=NuYZ
	UEpkdlDPA/MoPFg1KYmaCTdNZxzaMhmmXnS7n5Y=; b=RaMC69iL96yzOK/lRDf+
	5JstGQzPJTY3tGXJTW72lq1IMm7QXNtfTzTcW2dJzro8iQN+IyGFfOMigEK5kXJC
	TkrRPLlM6LLPe9Qif+6bs3GDBj8mFTAx3sj1CYxGfo0lwJ12gOLSKkDssy69M3pY
	kO3SoZGr2BJkk0iYM1n0FLY1CbFqNx1ykfaoWTx5Gb/OxbWLZcWDyIt9kLP3mzNJ
	cSuJlBH9j4SixMkwpaTYSSyeuOORn178xTCgNO7LWnmh8yB6rbXufNbbbx689Wdj
	/ONqFgUH4ENnnf762oQfQfPGjfmIXn9BhZXTOIt21neOwtoYd6cH77WqV6mIabu4
	Rg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9ccqvatx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:43 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8b58065ea15so159176376d6.2
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310243; x=1779915043;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NuYZUEpkdlDPA/MoPFg1KYmaCTdNZxzaMhmmXnS7n5Y=;
        b=UOWZrrywP7qMilYLWJz+NYPTW+siKBHFq9WmVx2Iq/ybV74YhGxTHHQ3M0qdHcV/8d
         aLlXG0fpnI0TVUwO+GffrAtXpra3bd/PkGbYUyAxdjuqWJJtqy+9pKlNZAS1xUfbd8Ht
         Ix+3V5CEYztMN3WT62lSab/2qAHMf+JNwc0Q99mUiUUQ89dyth534+MursYExUealkFH
         NdDyDk+IMx5XPbCqLnAViAJgAR28A12sZiEua54IIwOkfK7mawE4yms7lzgkRg457pGe
         B2m3De+cSQLw7MukxJrKkvbo+Uhj9u2rPf3AY62QspO5HOsBJ0cP4mGY7q6A0p9gXC88
         6zHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Bp8kSp6iz+7cBMzSdb6kKIUawIrAWfEvzswaHNHXrVuVtlRNmBGl+osEJuf2OARD9pI+Emp+/LA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVGa/pHeM5JQAmtTXLwqZAZF5jlnqGl9VfB378j289bL1ex0gi
	N5GrlT9RCTOPSm25e4e4II+2IufU7cziGZoXxsnrS9D66Eqtt36Iax6KNJyorq31sKFZZJLFKVt
	EDPQGFmrllD0/x4APWRqNZnU4QmBd9IuCN7Pr3tIQAOuj/J0DdBDVNmOgwl8xRRrt
X-Gm-Gg: Acq92OHbOtjmQ/2S6Yaqk0pGrRh+PWpd0uS7Ao4q5IbK2HdPzC7jdV2cnAgnbagGIYJ
	oyOEO0fmegrOHLZrxaLDEX5LJjwhWSY+Ya2oQNa4kjwfS6GbCPnwFliXSHx4Z4fiiC4hXXey83W
	7265a07D8t4O/W5ZFGOnHflFw1a8NEJLWdgMeyL0pwkvqN1Cu9Fw8tjNdWGUhVTA3M9dShhIvNc
	xrD1SaUYS6EUJEPcF6oY7oyUYsRuvRTwPANOzoHhPBh27iFKsSGUVNgVYd3ZW8Ipj4SnRFxPR/9
	nI+Hyv5VlpfGX3c1q9ogaaRi++IT/Ds08VKgKn8IQc/5nM5slF2aP8H6nO3qv1Iva5hV2bOuzvT
	jX94S6dUhLKhy5EBd9X7f6VWAYkOitqL6JzO6DV0JedGiYP+XCs/3z1XhkayqIddA0kulEZ12Nf
	HCcw==
X-Received: by 2002:a05:620a:258f:b0:8ed:dc5a:f668 with SMTP id af79cd13be357-911d00b7d27mr3703469585a.58.1779310242812;
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
X-Received: by 2002:a05:620a:258f:b0:8ed:dc5a:f668 with SMTP id af79cd13be357-911d00b7d27mr3703462585a.58.1779310242221;
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:01 -0400
Subject: [PATCH RFC 10/11] fs: move generic_file_read_iter() to
 fs/read_write.c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-10-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=8508;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sWXCb2voUNh/5RgXFZA32Pq1QXHhhJuRnYDZVKm8gu0=;
 b=c4SVT0/EKyeLALT++GoCtxlOHEW6EtdwGs6LfnqVwX3PEcOVGXnxyAlvuksJ5kGk//rUF733e
 +mKRneLOBHUCwxRiU2NqVzX9ZiVWHPnX8ZDbFnwJYl64fBDuIVt5eIF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=XJQAjwhE c=1 sm=1 tr=0 ts=6a0e1ea3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=gH0tmTfNonLjgA-2hfQA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: ycZy8_bLtax0Tm45ZU0pek4UR2E9SRMq
X-Proofpoint-GUID: ycZy8_bLtax0Tm45ZU0pek4UR2E9SRMq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX7eHo132q8FE5
 Xj/axXAYwGR7DWl0HpW4iD9jxEaMmy/V15tSfIXwQ5LUhN9TiBQknzbt6mkntj5Y2YsxmcLsbiK
 /iNt36+rLoE4u2X1f+H7hjtKo8fh8kf3jvtuP0TDBInX3S56fjXquOj4dnbxi7keAM8wVnIc/35
 7ZG34/BZXEwJm1gGMUnkElhJ8b3AToxQ+gwpd7ldPF30ETjtqi4IocKHUx4SzaJpgq0iJibPbr2
 CgL69NiafkvcfyqLwzZAOX/wsfdyD53Hy+5CTYhxqxCtKvUO6g2QLahWT/1rY9cOadWnDtrbZn4
 9PsKYPMCpeeyEOWKOvcecs289zqsffmksgoJrPk+3AVGScU38k53vQ+lq4U9FJdG9290WF4RmNV
 gZy/CVTfv2YT+yVi2GE+a73d/T72bExGfs8KriY1OeIO//aBt+MtXmczXSJxjkb+5VEGf/LBeg7
 OMEHyZmCr3fPnOhr1Sg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=10 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=10 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13470-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[columbia.edu:email,columbia.edu:mid,columbia.edu:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 09AF859A433
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

generic_file_read_iter() and its kiocb_write_and_wait() helper are
VFS-level read functions: Their callers are filesystems, and their job
is to glue direct I/O or the page cache (filemap_read) to a struct kiocb
and iov_iter caller.

Move both to fs/read_write.c, alongside vfs_iter_read. Drop the extern
from generic_file_read_iter()'s declaration and reflow the
generic_file_read_iter() definition to fit on one line too.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/read_write.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  3 +-
 include/linux/pagemap.h |  1 -
 mm/filemap.c            | 82 -------------------------------------------------
 4 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 50bff7edc91f..59ceea85c163 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -989,6 +989,88 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 }
 EXPORT_SYMBOL(vfs_iter_write);
 
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (filemap_range_needs_writeback(mapping, pos, end))
+			return -EAGAIN;
+		return 0;
+	}
+
+	return filemap_write_and_wait_range(mapping, pos, end);
+}
+EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
+
+/**
+ * generic_file_read_iter - generic filesystem read routine
+ * @iocb:	kernel I/O control block
+ * @iter:	destination for the data read
+ *
+ * This is the "read_iter()" routine for all filesystems
+ * that can use the page cache directly.
+ *
+ * The IOCB_NOWAIT flag in iocb->ki_flags indicates that -EAGAIN shall
+ * be returned when no data can be read without waiting for I/O requests
+ * to complete; it doesn't prevent readahead.
+ *
+ * The IOCB_NOIO flag in iocb->ki_flags indicates that no new I/O
+ * requests shall be made for the read or for readahead.  When no data
+ * can be read, -EAGAIN shall be returned.  When readahead would be
+ * triggered, a partial, possibly empty read shall be returned.
+ *
+ * Return:
+ * * number of bytes copied, even for partial reads
+ * * negative error code (or 0 if IOCB_NOIO) if nothing was read
+ */
+ssize_t generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	size_t count = iov_iter_count(iter);
+	ssize_t retval = 0;
+
+	if (!count)
+		return 0; /* skip atime */
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		struct file *file = iocb->ki_filp;
+		struct address_space *mapping = file->f_mapping;
+		struct inode *inode = mapping->host;
+
+		retval = kiocb_write_and_wait(iocb, count);
+		if (retval < 0)
+			return retval;
+		file_accessed(file);
+
+		retval = mapping->a_ops->direct_IO(iocb, iter);
+		if (retval >= 0) {
+			iocb->ki_pos += retval;
+			count -= retval;
+		}
+		if (retval != -EIOCBQUEUED)
+			iov_iter_revert(iter, count - iov_iter_count(iter));
+
+		/*
+		 * Btrfs can have a short DIO read if we encounter
+		 * compressed extents, so if there was an error, or if
+		 * we've already read everything we wanted to, or if
+		 * there was a short read because we hit EOF, go ahead
+		 * and return.  Otherwise fallthrough to buffered io for
+		 * the rest of the read.  Buffered reads will not work for
+		 * DAX files, so don't bother trying.
+		 */
+		if (retval < 0 || !count || IS_DAX(inode))
+			return retval;
+		if (iocb->ki_pos >= i_size_read(inode))
+			return retval;
+	}
+
+	return filemap_read(iocb, iter, retval);
+}
+EXPORT_SYMBOL(generic_file_read_iter);
+
 static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 			 unsigned long vlen, loff_t *pos, rwf_t flags)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 776cc82932a7..c0151ced8e7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3055,7 +3055,8 @@ extern int generic_write_check_limits(struct file *file, loff_t pos,
 extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
 ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
 		ssize_t already_read);
-extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index f86a550ad516..46cefd552a51 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -59,7 +59,6 @@ int filemap_fdatawrite_range(struct address_space *mapping,
 		loff_t start, loff_t end);
 int filemap_check_errors(struct address_space *mapping);
 void __filemap_set_wb_err(struct address_space *mapping, int err);
-int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 
 static inline int filemap_write_and_wait(struct address_space *mapping)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 079f9c3ac8a2..db7c53cd681b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2251,22 +2251,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(filemap_read);
 
-int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	loff_t pos = iocb->ki_pos;
-	loff_t end = pos + count - 1;
-
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (filemap_range_needs_writeback(mapping, pos, end))
-			return -EAGAIN;
-		return 0;
-	}
-
-	return filemap_write_and_wait_range(mapping, pos, end);
-}
-EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
-
 int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait)
 {
@@ -2302,72 +2286,6 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
 }
 EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
 
-/**
- * generic_file_read_iter - generic filesystem read routine
- * @iocb:	kernel I/O control block
- * @iter:	destination for the data read
- *
- * This is the "read_iter()" routine for all filesystems
- * that can use the page cache directly.
- *
- * The IOCB_NOWAIT flag in iocb->ki_flags indicates that -EAGAIN shall
- * be returned when no data can be read without waiting for I/O requests
- * to complete; it doesn't prevent readahead.
- *
- * The IOCB_NOIO flag in iocb->ki_flags indicates that no new I/O
- * requests shall be made for the read or for readahead.  When no data
- * can be read, -EAGAIN shall be returned.  When readahead would be
- * triggered, a partial, possibly empty read shall be returned.
- *
- * Return:
- * * number of bytes copied, even for partial reads
- * * negative error code (or 0 if IOCB_NOIO) if nothing was read
- */
-ssize_t
-generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
-{
-	size_t count = iov_iter_count(iter);
-	ssize_t retval = 0;
-
-	if (!count)
-		return 0; /* skip atime */
-
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		struct file *file = iocb->ki_filp;
-		struct address_space *mapping = file->f_mapping;
-		struct inode *inode = mapping->host;
-
-		retval = kiocb_write_and_wait(iocb, count);
-		if (retval < 0)
-			return retval;
-		file_accessed(file);
-
-		retval = mapping->a_ops->direct_IO(iocb, iter);
-		if (retval >= 0) {
-			iocb->ki_pos += retval;
-			count -= retval;
-		}
-		if (retval != -EIOCBQUEUED)
-			iov_iter_revert(iter, count - iov_iter_count(iter));
-
-		/*
-		 * Btrfs can have a short DIO read if we encounter
-		 * compressed extents, so if there was an error, or if
-		 * we've already read everything we wanted to, or if
-		 * there was a short read because we hit EOF, go ahead
-		 * and return.  Otherwise fallthrough to buffered io for
-		 * the rest of the read.  Buffered reads will not work for
-		 * DAX files, so don't bother trying.
-		 */
-		if (retval < 0 || !count || IS_DAX(inode))
-			return retval;
-		if (iocb->ki_pos >= i_size_read(inode))
-			return retval;
-	}
-
-	return filemap_read(iocb, iter, retval);
-}
-EXPORT_SYMBOL(generic_file_read_iter);
 
 /*
  * Splice subpages from a folio into a pipe.

-- 
2.39.5


