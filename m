Return-Path: <io-uring+bounces-208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B818E80245C
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 14:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4E6A1C20962
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 13:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F2C154A4;
	Sun,  3 Dec 2023 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ak1pHU9u"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0CAFC
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 05:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701611273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWlPk5ps4uB2wUS/PZIOJ+KKMunM3nwqSoV4TDMNswQ=;
	b=Ak1pHU9up4M4dZs5qSDaGCYIQl3WqfzCkm8e2HECHp0/aYJRsJVlisQugi/kJBQiTO/aUM
	OveaEK0MZ2BhFcjqQj1QBs9IsK9DDBUeFtGPhKQ2EBrICMPSe/sMG1hfhmphQy+924JARp
	uuKNbV9JF0JVZCgXY7n7Net/H4Q58mc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-bhdUvB-qPeqtyjKp37lYsg-1; Sun, 03 Dec 2023 08:47:49 -0500
X-MC-Unique: bhdUvB-qPeqtyjKp37lYsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA8FB85A58C;
	Sun,  3 Dec 2023 13:47:48 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9C072026D4C;
	Sun,  3 Dec 2023 13:47:43 +0000 (UTC)
Date: Sun, 3 Dec 2023 21:47:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, joshi.k@samsung.com,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v2 3/3] io_uring/cmd: inline io_uring_cmd_get_task
Message-ID: <ZWyG+nISHhX3+a1s@fedora>
References: <cover.1701391955.git.asml.silence@gmail.com>
 <aa8e317f09e651a5f3e72f8c0ad3902084c1f930.1701391955.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa8e317f09e651a5f3e72f8c0ad3902084c1f930.1701391955.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, Dec 01, 2023 at 12:57:37AM +0000, Pavel Begunkov wrote:
> With io_uring_types.h we see all required definitions to inline
> io_uring_cmd_get_task().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


