Return-Path: <io-uring+bounces-13462-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iE1/BXktDmrz7gUAu9opvQ
	(envelope-from <io-uring+bounces-13462-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 23:54:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E57F59B706
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 23:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E044030A51F7
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46143376A00;
	Wed, 20 May 2026 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XGeFG2dq"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61481374169
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310241; cv=none; b=pBlclTt3ZBgPLEEB/IEJzxLQLEQuJe1nWcySh5vf1nyn+IKKvJDW1jEUnJQcns2oW4x5vrFbXjC5P0JyauNuHtznipTi9td03XFHhZ/vHLKq5YVgooubHDgmqTnqi0pdYX8y//3Gxb1ijkOxW8UQ1odwIlyupjtoh+ubdGkK9Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310241; c=relaxed/simple;
	bh=0hEAxH6OSygPLgsPWvuM0zul/qd7ww1B3y3E3CXvzOo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=OHDxur28ZoqP+BwSgu8AnZGQ8+Ezf04HybshgZozI/8Sfm+PCaaPbI1M4DDfCnvslW53W7YwyCXdOdWmUwENwEksP5qZuN59P1QAVff24wvwR4h21Uh1ThNnlNL0wiXo2Mn2Z76MWTbW0irCyGK5MyPN92uzktCTODR6P14n1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XGeFG2dq; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO3uV708915
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=vWEqqBLqiHXKQCYkt4eI7nkTUL
	jtzTI1duVNgJdotDw=; b=XGeFG2dqy2N3gbIr20V1uslI7BA0Xd7pIYogyLnBlz
	qkv1ZoJ51iFNeUnZQ28voJfms3i4J/xG9Tvp1XEbqtuozNf5FBh3YiYb6elAwEOO
	+hCbUDddgCRJ/VR3ZMK5N43M8+5idUDk6gx4qOh8gFKwk8POVXOLDeSdcerGQURV
	FE/WTX+yuXoQMuVKi6wNqn11InNK3e2fr2M5xf3AXOmFjJQlgZmue0e4cGHQ2UIU
	5D2xKBrlIa6jswsRFLypsF5wkuPt20fND3ldlwfWHeQy84NvgjOjIpXsQMC9/se+
	N8MYZoxnljImx5MDYxvXHPblaSdThVHR1funfYxh9DXg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e99ydd0q2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:31 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90d7b3406b2so1288373485a.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310231; x=1779915031;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWEqqBLqiHXKQCYkt4eI7nkTULjtzTI1duVNgJdotDw=;
        b=Y1yO8Nl/KD8YQeEq1TD1X9pyoVoBdMWaA9YfwfewvZILYIQ3pcVDcLOKFfK59WlNfl
         vd5c20Sszq0XVufAaM55YheIQeKlvkA/R0pTumuOwUIz/y6vxaTNSaLX3WXrmEZdU9d8
         HBnS9h32Ojb71SxqHUQBrYVsflly7TnGKAzNKmJIx4p0CwFks9qP/3jUFi+Fb4aXNWzp
         qB7luBsQgmDNwG/SJY09tibgyLhMl0Bx8PWAv25i28JqhTnJN9v8xJnA7JhPBDjNOTT+
         Jgaka8+S7ha6yaiqhkNjd2c4dl7UuKYwcGz1imSOfIUlYsVi3/QJtAGewFZsG4lKlsA1
         +TYA==
X-Forwarded-Encrypted: i=1; AFNElJ+zfw3Hckt18OrvxPdYgTHEUZpXiTwvTQtqrOZ/YjwgfLoXXy27KlviERTzj6UCWs5Syaw7NMCwiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcQoKx9aRIb4zcFZuEvFq2OgK/DGdtHudCp5yA4UpFfb4O6VvK
	q1C1CXdg8+ACQnA/ev7Dyl9t43MH20A9J29pwMQnlK6o221LoEcpui/4wzM8kg9tsmwYmUgsYHr
	j/wg1Uwm1sJUTzp9Q2Q683+rbGNdzGQfmo7lCEPFi8OLxyCXL6aYMwFq3
X-Gm-Gg: Acq92OHXwGgn7ipKQe6GvLER87rF95XXnWA3UkIJDaYwLbFYPhFhDS0p6djyehcsSgW
	g7JUmvtj7GUAIKxuz5l1SPLkojaT3oDLqfj2BObetCnIaWFIwKZ3SD/P3yDEofZpOataho/2RSd
	n6+ql/54Eanb9zJ0GvSWFjrjN2imES/9A1EvsV0mka9NJRNPdZdqXwcwXbYxIWg22J24neeCdLd
	wT4T9dFN4HCvvCJb2LEu5GU16uLV9eUeas9xdsJZYWgozhENPYcbpp8K8z7EGOyhRxy0rGJxO43
	FuBUL2rLIOvmWDx6MIR8/AfxtkmzaXfkkF8vVHTu3jAUo3iXMFJM0IU8efL/ISNa7Mo3ffIMtEK
	U4Zyk4GMURZrTXwSYc5cEFa8lO/4hdGn0G12S64l6QbkOzQF+r70joQxNcDD+YJyJkQk=
X-Received: by 2002:a05:620a:1994:b0:90f:9cde:9781 with SMTP id af79cd13be357-911cdf4e848mr3838242585a.14.1779310230852;
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
X-Received: by 2002:a05:620a:1994:b0:90f:9cde:9781 with SMTP id af79cd13be357-911cdf4e848mr3838238585a.14.1779310230349;
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Date: Wed, 20 May 2026 16:48:51 -0400
Message-Id: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADMeDmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0ND3bTMnNTcxALd4oKczBJdC3PDJNNkQ4tUS4tkJaCegqLUtMwKsHn
 RSkFuzkqxtbUAjO/UHWQAAAA=
X-Change-ID: 20260511-filemap-split-871b5c18e98c
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=3123;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=0hEAxH6OSygPLgsPWvuM0zul/qd7ww1B3y3E3CXvzOo=;
 b=NI+xM1sj15FzhmwcsYKgafgGq17ATxKLg9pL8kkBXvje15rDxNOFgGPrNNnyq8u4PLDHh0Ztz
 uvcMqRkQw3SDEKwQl4Xi/ayhWnIis5Q4rM7dUmjykLQ6nMy3iE8z/p8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: UaCx7hH0wJbmh7YcefkFv4lXb3CCgYj5
X-Authority-Analysis: v=2.4 cv=TbKmcxQh c=1 sm=1 tr=0 ts=6a0e1e97 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=5qPNtsZOevHdRsu6XPgA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXzKRoeRmAxFkt
 3xJNrwhtysyFogcpE5jpbcHKjrTbga2OTXab+pTF8fC/nBXSCF3IYWzXwzxYcwsF6oQZOfhgIbr
 0bD62ewQQX3+YaJ9q8xiG5rvWS+nxSzgwee+8jxnyeq6usQPH1LXwMJMQvHmdOiK5HBoCnWs8TG
 zSLmKWG7P1mdQCADGZUeJXLUjpBKugXs7iF4g5r3ALykEE4qXXQeTrs2qVSGFqoUSMiWJpc3mqG
 6Dq7x5LR5i5Mdjsuqlxhnt3siyRR7u3j9BUrC1yqyPg1R5CmqflIbL6V6cDlE3Qbk4CZQQL7TEw
 4trB/mmm3Nv8spq3oz6ApdkV+ezReDvaDTztUKrUc+mEDnPRm/mPyd+gLA6HeQcHz35zk6kilYX
 Ol3JQdSQiO12E+3PRh+G4Y+6SPy0qOm6M6vh5p5KLcneyb54NhTWk3Kc6XWtwW+Caj8Ol/o9dAw
 OqfcxL5rbDSQh9PZHOg==
X-Proofpoint-ORIG-GUID: UaCx7hH0wJbmh7YcefkFv4lXb3CCgYj5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1011 priorityscore=1501 bulkscore=10
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=10 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13462-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[columbia.edu:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 1E57F59B706
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

mm/filemap.c has accumulated additional infrastructure over the years
that is not directly related to the page cache. It is currently nearly
5000 lines long. This series splits out the folio bit-lock and wait
queue code into separate files, and moves the VFS-level
generic_file_{read,write}_iter() family of files to fs/read_write.c, in
order to provide better separation of concerns. This also slims down
mm/filemap.c by ~1000 lines.

The folio wait infrastructure is centralized in mm/folio_wait.c and
include/linux/folio_wait.h, with functions moved from mm/filemap.c,
mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
is cleaned up a little, with functions and data types renamed to refer
to folios rather than pages.

generic_file_{read,write}_iter() implement the VFS-level read/write path
for filesystems, including support for direct I/O. These functions and
their helpers are moved to fs/read_write.c, along with other VFS-level
read/write functions. dir_pages() is also moved to include/linux/fs.h.
i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
requires folio_size(), which is not currently available in
include/linux/fs.h.

No functional change is intended.

Note: I have additional cleanups to mm/filemap.c ready to go, foremost
among them centralizing on the filemap_*() naming convention and making
the exposed page cache API clearer and more consistent, but I've split
these patches off from that in order to avoid sending these logically
separate patches to ~60 maintainers.

---
Tal Zussman (11):
      mm: add folio_wake_writeback() helper
      folio_wait: move folio bit-lock and wait implementation to mm/folio_wait.c
      folio_wait: move folio bit-lock and wait declarations to include/linux/folio_wait.h
      folio_wait: move folio_wait_writeback() family to mm/folio_wait.c
      folio_wait: reformat comments and fix alignment
      folio_wait: rename wait_page_* infrastructure to wait_folio_*
      folio_wait: convert VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO()
      MAINTAINERS: add folio_wait files to MEMORY MANAGEMENT - CORE
      fs: move dir_pages() from <linux/pagemap.h> to <linux/fs.h>
      fs: move generic_file_read_iter() to fs/read_write.c
      fs: move generic_file_write_iter() family to fs/read_write.c

 MAINTAINERS                |   2 +
 fs/read_write.c            | 358 ++++++++++++++++
 include/linux/folio_wait.h | 183 +++++++++
 include/linux/fs.h         |  19 +-
 include/linux/pagemap.h    | 184 +--------
 io_uring/rw.c              |  14 +-
 io_uring/rw.h              |   6 +-
 mm/Makefile                |   2 +-
 mm/filemap.c               | 993 +--------------------------------------------
 mm/folio_wait.c            | 710 ++++++++++++++++++++++++++++++++
 mm/internal.h              |   4 +
 mm/page-writeback.c        |  66 ---
 12 files changed, 1285 insertions(+), 1256 deletions(-)
---
base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
change-id: 20260511-filemap-split-871b5c18e98c

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


