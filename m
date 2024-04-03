Return-Path: <io-uring+bounces-1385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55AF9897881
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 20:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8654A1C268DB
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 18:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D341553A2;
	Wed,  3 Apr 2024 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyZAJsdr"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1182315530F
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712169947; cv=none; b=BADUuVM5l9C1W1Q0/udLlb6azHr8zhNkGNRvGidxCUQ0jNBde1KQWEdSc5ZgIrNWZK04nONXiq8g4XKJwC3CnklucgvZufmF4q/PzxOYLZLFRS0xBAZJQJ1HbR6/53AWFcKnwly15D1k0RMbgQPoacJKRlFnL8tNocPa5MgelSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712169947; c=relaxed/simple;
	bh=L+c4CgJ50DWLl6QnvHMoiHvgcpsBtXF6Sr2vLdXwPLQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p1KkpLhdN0PFRywZZgxe5HbagpGUG86bOn6hOhJWKuEpf94hOufSkOsQpoNrnOUtEJ6vBekG2OuYE6u46IUWX5/KkSlMXlQSZD/B0PHTHdlzyPnFyMuY/bQhnS9Ub1eCWDTaR7bCMHJbkLBiRGEBBjBeb8suQYHztvIjlvBSh88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dyZAJsdr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712169945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=iIsMQRGL+wSwclO7RidwGSyvA5C8Q2QbVGGVF0KRxSs=;
	b=dyZAJsdrDhggjQJTU+y66bB+2izwydp5CSmyMWbq5CWoymNXeesbroBu2vaACTChgRUUlc
	zZHkDk/Tl+3w7nhqJMGj6jXtAEym2+XBT9NZumb7WoZcd+qGQt6zSrHuXs3YXkzYBD7pmQ
	nXzpk1y6ctjW45dMEnAPDIMDoYP99WY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-Ju7w37ljNbm_Xd0IBh0jLg-1; Wed, 03 Apr 2024 14:45:43 -0400
X-MC-Unique: Ju7w37ljNbm_Xd0IBh0jLg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BC9A8007A3
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 18:45:43 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.34.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF61E492BC9
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 18:45:42 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: io-uring@vger.kernel.org
Subject: [PATCH liburing] man: fix IORING_REGISTER_RING_FDS documentation
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 03 Apr 2024 14:45:42 -0400
Message-ID: <x49o7aqs2sp.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The documentation for the 'arg' parameter is incorrect.  Fix it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index fbfae2a..09823bd 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -528,8 +528,8 @@ of the ring file descriptor itself. This reduces the overhead of the
 system call.
 
 .I arg
-must be set to an unsigned int pointer to an array of type
-.I struct io_uring_rsrc_register
+must be set to a pointer to an array of type
+.I struct io_uring_rsrc_update
 of
 .I nr_args
 number of entries. The


