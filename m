Return-Path: <io-uring+bounces-1721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB898BB537
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76F46282F36
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63381EA87;
	Fri,  3 May 2024 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/54DxdD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183E134B1
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770354; cv=none; b=WvaicAaAVU3VTachTyAUjGPUBnxlzrtBR+xTaqzIfK7I2roBt+d/KUXOAQoCTtur9sBEUlOx+6oHm/xUP3RZ0RrgseUORGrEDGCyK7qTdkMothe2/+kkqzjzWotXPjPpx7qzpVLzcL/fD0URd9tDmFQe4agi9vfoZxVIjucjR8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770354; c=relaxed/simple;
	bh=BRTTM808LyLJDWB7mFF14X4AB1fddYDAEns7VnsAA/g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jdo0+ArogNJ3+JGb2Hjb1J0vN7GvnonDEbLWqp5bl4pLVuIDsWAhSvZrxi0zrTQQQY1SlTR8hKOdTL76SE5ewKaVkEtPBV4BJqTS+FOtMzKztVcCEwHeX4AgnxS4fEOoCkumXk9rOOisVfzUGaCWMiqXvZJjK2nifsCClViG5Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/54DxdD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714770351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=22XUfJytmrtrjXGHeWb7o/ZQTLhKZb5rocdce6TXnYk=;
	b=O/54DxdDY7l+ZF8SxVsLnzGFqP2hIe10PPvw5Z0rsjM/E9kyFn2qPNEO4rcE7xz23MTqNg
	FmwYbvvPg+HnS+Vp09Bp2B1GEWXtQqKmlwMqQW82ZbMiDu5EzOrgXv7We3z5PSKSWDz3sV
	FnvBotnnzTXGeNY27ElLofpuihWtjWo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-SK2C_zxXMYe9d9NFd7Q_Bw-1; Fri, 03 May 2024 17:05:50 -0400
X-MC-Unique: SK2C_zxXMYe9d9NFd7Q_Bw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 010C38943A1
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:05:50 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.16.155])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3FAD2166B31
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:05:49 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: io-uring@vger.kernel.org
Subject: [patch liburing v2] man: fix IORING_REGISTER_RING_FDS docs
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 03 May 2024 17:05:49 -0400
Message-ID: <x49bk5mehci.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

The documentation for the 'arg' parameter is incorrect.  Fix it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
v2: fix up IORING_UNREGISTER_RING_FDS as well

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index fbfae2a..4590588 100644
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
@@ -570,8 +570,8 @@ Unregister descriptors previously registered with
 .B IORING_REGISTER_RING_FDS.
 
 .I arg
-must be set to an unsigned int pointer to an array of type
-.I struct io_uring_rsrc_register
+must be set to a pointer to an array of type
+.I struct io_uring_rsrc_update
 of
 .I nr_args
 number of entries. Only the


