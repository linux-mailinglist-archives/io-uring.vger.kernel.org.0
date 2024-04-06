Return-Path: <io-uring+bounces-1427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B83F89AB0A
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 15:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1185E1F21530
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 13:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D33364A0;
	Sat,  6 Apr 2024 13:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxFAq8B/"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE434CD8
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712409697; cv=none; b=G73R2minH9xeDvtpatil2Pr+kj1lS5ziyBbkSL12fbZgcvk56Bv0yxrStgAiB0pLoJfiVwdDBVYfO+nQb55WwauoMGA//V/wcdR+4Xf4KpD8z+OvsfwbR31mZlqc378Fp2rEYq43yTJtIFiKL8BRN3J1hHW7K/NO03JGmlPcEts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712409697; c=relaxed/simple;
	bh=UWVisIvrcOa5wYrbe/PnbpetP37rdoo4V0sDoLjOUWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apS/t8FYzG1NQ24uhvwdGbfy6n8Bh+Uu2TPBdeOod1LaXJTGVRIxIp4BIsRws6wFzbxlD+13X+XxhE4W4+EtfFGkIi27nObUx0FroRJtHVJDrd8SsqvrgMGgqsiq9E2A7mnfZu0uu+IN2NmxISdGN5HfeKbhs8p2UoDx0LTBK20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IxFAq8B/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712409694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pvdXOmstIuRTrdbgWd/xb8YK+GCPhRKwPKcbT5L02vw=;
	b=IxFAq8B/uvjyumvwWl1jzxvBeXWrzktN/VySdEf8CF55JJ+E0/KIgvlvzS+r4m7kFg0Wbx
	HNp/BqELNXurDvbtTqtGA8B2UGiJuTHzlPrkVju3+gfBepoJGwGcZctwBRLIVyjDhyqRfV
	0kB8zVK06S2JiMyEWgYsE1iYY44YiwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-kHd8OpnQMT26Hu1qsZJ59A-1; Sat, 06 Apr 2024 09:21:30 -0400
X-MC-Unique: kHd8OpnQMT26Hu1qsZJ59A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73A72185A781;
	Sat,  6 Apr 2024 13:21:30 +0000 (UTC)
Received: from fedora (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4A9A492BD0;
	Sat,  6 Apr 2024 13:21:27 +0000 (UTC)
Date: Sat, 6 Apr 2024 21:21:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 2/4] io_uring: turn implicit assumptions into a
 warning
Message-ID: <ZhFMT5w/Q1m1jtbB@fedora>
References: <cover.1712331455.git.asml.silence@gmail.com>
 <1013b60c35d431d0698cafbc53c06f5917348c20.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1013b60c35d431d0698cafbc53c06f5917348c20.1712331455.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Fri, Apr 05, 2024 at 04:50:03PM +0100, Pavel Begunkov wrote:
> io_req_complete_post() is now io-wq only and shouldn't be used outside
> of it, i.e. it relies that io-wq holds a ref for the request as
> explained in a comment below. Let's add a warning to enforce the
> assumption and make sure nobody would try to do anything weird.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


