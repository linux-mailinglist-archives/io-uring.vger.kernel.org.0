Return-Path: <io-uring+bounces-1130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D167E87F518
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AF54282526
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 01:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040B564CD1;
	Tue, 19 Mar 2024 01:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jENFTd8W"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285CE612F6
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 01:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710812288; cv=none; b=RZrf2f7lqnKhWMfW2H77anCby37SEedfp51BV9PEAUvKl6uZEtpbizURQrSmgCZXndRCAxKa4MniN4IyO1VoKBqnJKKFdPc+WKLuWxHWy/hcHZCopRjKD7X3XPZ1nwi1++k8Ya+Fu0hh0SeulGv0SnHNFTgIDNYtWL2V4MNkx0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710812288; c=relaxed/simple;
	bh=QzHQ8Gb52d/iPIXsmO4Q7K5HCYc1N9KnF/HN4e8tItI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Py2NY5l5eq+ubajmWaptBbVEmnSVnB/pGt5utu+yQimZ3nmGlARlfejh81q9HR4LIGTN5b/auZOSH4e4O7IC8cCKDbGP054xZF+SJFf/pYDog8+l2dzpxt3Ej9LRBHOE0Jv0/Xbi15V8VLbaeJU+SgTeo68U8n2xAtVJnZOe2Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jENFTd8W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710812285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=72CtFGfkL4Dj9UlaSsYPkg0epFX1gszhXQkW4mvKUII=;
	b=jENFTd8WaqlMDc19aMg7YBEmI19x+xJta3WFIIkm0jrXRZzECujII7UcGXH9Q3gNd4ltbE
	BRMNR5zXoVQUnbIUMkXQJYpmKyrn/dkauV29Xg8giPXCVAMtU6qhh1B0Z/lKY9IuNScruf
	S11Azup4w3WevT0MhVviaW7kFr3RsvU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-nosPWf4iPFO0LTxaDvSmxw-1; Mon, 18 Mar 2024 21:38:00 -0400
X-MC-Unique: nosPWf4iPFO0LTxaDvSmxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5130D8007A3;
	Tue, 19 Mar 2024 01:38:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A276200AFA3;
	Tue, 19 Mar 2024 01:37:56 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:37:46 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 03/13] io_uring/cmd: fix tw <-> issue_flags conversion
Message-ID: <ZfjsarflISTu5pMX@fedora>
References: <cover.1710799188.git.asml.silence@gmail.com>
 <aef76d34fe9410df8ecc42a14544fd76cd9d8b9e.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef76d34fe9410df8ecc42a14544fd76cd9d8b9e.1710799188.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Mar 18, 2024 at 10:00:25PM +0000, Pavel Begunkov wrote:
> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
> pass and look for to use io_req_complete_defer() and other variants.
> 
> Luckily, it's not a real problem as two wrongs actually made it right,
> at least as far as io_uring_cmd_work() goes.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks
Ming


