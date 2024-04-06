Return-Path: <io-uring+bounces-1428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 813AB89AB14
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 15:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EB721F21345
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 13:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895391E4B0;
	Sat,  6 Apr 2024 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kr4coVrg"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05CA2B9CE
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712409998; cv=none; b=OBc88LYgkeZhLWbFxCk1Jl5/lZJRoJUB6V8NddIkhotlIurXp943Tg0UtmDgOzGd0GCjklMzaym7e0Y9Tf2QrjkDYeJJqD06kr14kIIf3Vn2DRETZx2NCqcNtuaqeymfhlF1JUhwI7rWKPH62WJB+NrQgou9Xv2PZ2U42bphpSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712409998; c=relaxed/simple;
	bh=kL7E3vzhQ/pyXSMvA8ZOuyFhF0KpCgyfwGrHJPG1/nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM+Brw7Yw57P5R0iiwLrDhRbOOeNeEa1BvxDQFoYc/HFUlIFwUbt3iZwHERR4ql6eC3h5VTo8NUXahzhQbEXpcW++Icuj5KSbkKJ95+RzUmhzEnP6lxSX5OzyeCL1SHe1rBIwr2jDqA2C0F9y5sWZKqC1iPfvi6yJvq1MecL5PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kr4coVrg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712409995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5P44CS9K50CLvIfYaMpmbzWJUhNrCLWU+DCMRxWOFnw=;
	b=Kr4coVrgNlqUdnu56HKscMqHwd+WFE1MUale00/KHqfD8O+NXISKGmILZ3SEPrLfgGKiQ5
	w80iWwZ16pElYPppfIM+OV0X+2q6Cvnfxrz+NKAxx1+aNyFhB6QIDS8tnHz711L8vSihs6
	CJwTyXlwJSRfW0RWR5rWiREP0qSKlqs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-ZmY9yAhQOOe36-cB2fPtow-1; Sat,
 06 Apr 2024 09:26:31 -0400
X-MC-Unique: ZmY9yAhQOOe36-cB2fPtow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA0AC3C01C15;
	Sat,  6 Apr 2024 13:26:30 +0000 (UTC)
Received: from fedora (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AF471121337;
	Sat,  6 Apr 2024 13:26:28 +0000 (UTC)
Date: Sat, 6 Apr 2024 21:26:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 3/4] io_uring: remove async request cache
Message-ID: <ZhFNfJRuEdgrtJRJ@fedora>
References: <cover.1712331455.git.asml.silence@gmail.com>
 <7bffccd213e370abd4de480e739d8b08ab6c1326.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bffccd213e370abd4de480e739d8b08ab6c1326.1712331455.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Fri, Apr 05, 2024 at 04:50:04PM +0100, Pavel Begunkov wrote:
> io_req_complete_post() was a sole user of ->locked_free_list, but
> since we just gutted the function, the cache is not used anymore and
> can be removed.
> 
> ->locked_free_list served as an asynhronous counterpart of the main
> request (i.e. struct io_kiocb) cache for all unlocked cases like io-wq.
> Now they're all forced to be completed into the main cache directly,
> off of the normal completion path or via io_free_req().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


