Return-Path: <io-uring+bounces-206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE98580244F
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 14:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62FF01C2092E
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 13:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBE211C8F;
	Sun,  3 Dec 2023 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mlm9ZjJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F368AF2
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 05:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701611147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kfhCG1IvV1CGYP/X56tZVstBaEZXadDb3GV0BKEnzfc=;
	b=Mlm9ZjJJaqwOHAasy/CqKh7WedqF38fAAWcZ8a4vsi5k9+bAxEvtUeuBr6h8XwtcSEenkV
	SlIafRuQXK49krUgvs+COrJbHkDzBykx2+83aNgtlQuQWPovzESEYdrPMSG82NijaaRKVe
	3vLg32y3jgncurhng1vWXrfRX1A6Gis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-XBxcx_AAOeKs96EAlSyfxQ-1; Sun, 03 Dec 2023 08:45:41 -0500
X-MC-Unique: XBxcx_AAOeKs96EAlSyfxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 508D8185A781;
	Sun,  3 Dec 2023 13:45:41 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E1DD2166B26;
	Sun,  3 Dec 2023 13:45:35 +0000 (UTC)
Date: Sun, 3 Dec 2023 21:45:30 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, joshi.k@samsung.com,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v2 1/3] io_uring: split out cmd api into a separate header
Message-ID: <ZWyGepj+F8JgGjmh@fedora>
References: <cover.1701391955.git.asml.silence@gmail.com>
 <7ec50bae6e21f371d3850796e716917fc141225a.1701391955.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ec50bae6e21f371d3850796e716917fc141225a.1701391955.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Fri, Dec 01, 2023 at 12:57:35AM +0000, Pavel Begunkov wrote:
> linux/io_uring.h is slowly becoming a rubbish bin where we put
> anything exposed to other subsystems. For instance, the task exit
> hooks and io_uring cmd infra are completely orthogonal and don't need
> each other's definitions. Start cleaning it up by splitting out all
> command bits into a new header file.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


