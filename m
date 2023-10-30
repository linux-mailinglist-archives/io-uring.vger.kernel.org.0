Return-Path: <io-uring+bounces-4-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C849F7DB240
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 04:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31FD32813D5
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 03:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A686EBD;
	Mon, 30 Oct 2023 03:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VnT0BiS1"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F018EA3
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 03:20:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36234C1
	for <io-uring@vger.kernel.org>; Sun, 29 Oct 2023 20:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698636048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=P6Jst2cnwGRfUR0jda/O+BDtsFhLRLTlD3CHHxL3Bjw=;
	b=VnT0BiS1XqjJDqraIlmQLywGd8Oi+82D0HtoI3N3qIbVNOH85G2d6iVN1RRxV3Ob1oCS+L
	oc8gt7YPo9RWgdACn9ELX7cE12DGATflB5obCgHUm202VKGQ0t1jhmfyThllVhps9KOiVN
	u50g1c+mq/lw9u8/c4cPuk/Cvnq7AXk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-158-30ikrEmSOBaVQkRnS8qtMg-1; Sun,
 29 Oct 2023 23:20:44 -0400
X-MC-Unique: 30ikrEmSOBaVQkRnS8qtMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1B511C05153;
	Mon, 30 Oct 2023 03:20:43 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6747C1596D;
	Mon, 30 Oct 2023 03:20:40 +0000 (UTC)
Date: Mon, 30 Oct 2023 11:20:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc: ming.lei@redhat.com, ublk@googlegroups.com
Subject: libublk-rs: v0.2 with async/await support
Message-ID: <ZT8hBFcmmHsw9cDY@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Hi,

libublk-rs v0.2 is released:

https://crates.io/crates/libublk
https://github.com/ming1/libublk-rs

Changes:

- support async/await for generic async fn(don't depend on runtime) and io_uring.
- unprivileged ublk
- queue idle handle
- almost all features in libublksrv are supported in libublk-rs now
- command line support for examples

Now each io command can be handled in dedicated io task as following,
and it looks like sync programming, but everything is handled in async
style:

         let mut cmd_op = libublk::sys::UBLK_IO_FETCH_REQ;
         let mut result = 0;
         let addr = std::ptr::null_mut();
         loop {
             if q.submit_io_cmd(tag, cmd_op, addr, result).await
                 == libublk::sys::UBLK_IO_RES_ABORT
             {
                 break;
             }

             // io_uring async is preferred
             result = handle_io_cmd(&q, tag).await;
             cmd_op = libublk::sys::UBLK_IO_COMMIT_AND_FETCH_REQ;
         }

Roadmap:
1) write more complicated targets with async/await

- re-write qcow2 with clean async/await implementation in rublk project which
depends on libublk

	https://crates.io/crates/rublk
	https://github.com/ming1/rublk

2) tens of thousands of ublk device support
- switch control command to async/await, and make ublk device in one
  thread with single blocking point

- shared task: one task can create multiple ublk devices

- shared uring: create multiple ublk device with single uring.

3) support tokio async, especially for non-io_uring target io handling


Thanks,
Ming


