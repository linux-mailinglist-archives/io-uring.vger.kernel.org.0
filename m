Return-Path: <io-uring+bounces-1429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FC089AB18
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 15:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 776A61C20B5D
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 13:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2872B9CE;
	Sat,  6 Apr 2024 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bFCoEupf"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5A171C4
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712410156; cv=none; b=Ugq9t/4Bn618ADhXVuIzi/UIoKNPx9SWgleCQOe+kuQR5Yb3N4omvC3g1BTtmjZdWuq7Di4VukOl748pwxT1oS0f6Vb+nFYZFJZiNPqo8RJhHg8bRrDsi37WTe4IajK9I/nh2pmdT7gCrJ+VWwLw427SWtHmaFK2AR/mleHpfSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712410156; c=relaxed/simple;
	bh=p+bR0UbfAP0lpGVgFnaMJC5DVwKZapvzqwlwm77g24g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlnZ2eoMClMEKtJO+747g2drvFKp+zC5NngPzSEEHx7LynG00vgx8Fh5yQxme4xXLwIuiRY2gp7N+QR8ubFKKZPIw0Hb8GM78hte+p4ZUSUrNSnWe0kAXsl1J+JJz5bbFRPdykG53oIV3jEeDwursGbSZy8S7NDEHo/O8RCOMXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bFCoEupf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712410153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uMQi0AhJ74qjPjuuIZPdDPDyBiNrCSESI73KXJDypw=;
	b=bFCoEupfdoo2e8OB+n0770Our6dIQWQH8YCvLR5OB8IWkaxa4QHVilgDsQsuIRHKZarvhX
	HuH8A0maFZ9lJJMA3lhV98K7qI1hyjci+PTeVc7NfR5r42xHpFNK2AkmUqLqnLq0ePkmQm
	yEqd5NAiAba5bbD2JvvJqgZzp/+4wLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-ErHFfEezO0GRGTCaIgRa5Q-1; Sat, 06 Apr 2024 09:29:10 -0400
X-MC-Unique: ErHFfEezO0GRGTCaIgRa5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB4D58007A1;
	Sat,  6 Apr 2024 13:29:09 +0000 (UTC)
Received: from fedora (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9670A2166B33;
	Sat,  6 Apr 2024 13:29:07 +0000 (UTC)
Date: Sat, 6 Apr 2024 21:28:59 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 4/4] io_uring: remove io_req_put_rsrc_locked()
Message-ID: <ZhFOGxTx/+i8v1gS@fedora>
References: <cover.1712331455.git.asml.silence@gmail.com>
 <a195bc78ac3d2c6fbaea72976e982fe51e50ecdd.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a195bc78ac3d2c6fbaea72976e982fe51e50ecdd.1712331455.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Fri, Apr 05, 2024 at 04:50:05PM +0100, Pavel Begunkov wrote:
> io_req_put_rsrc_locked() is a weird shim function around
> io_req_put_rsrc(). All calls to io_req_put_rsrc() require holding
> ->uring_lock, so we can just use it directly.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


