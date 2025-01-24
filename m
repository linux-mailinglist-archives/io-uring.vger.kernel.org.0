Return-Path: <io-uring+bounces-6113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02233A1B870
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 16:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D8EB1635E6
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 15:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0572714A0BC;
	Fri, 24 Jan 2025 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="wFh8fH07"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3051913AD20
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737731320; cv=none; b=hpzqw+6+TUzp5Zph/mmpee0c0CH9YVuIvG/A1q4GxRxMd9cOC5Ue8XIKmTM0lUWkMffnu9QKQ6LVffa5f64xLbdeJAqCaCZ1NoZ0qUQNkv/tVh5uetEhFEedj5HhjeDRHD5hjuYPpuIo9l36Pjrua71TIpze6JfTdmkEfMKRWyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737731320; c=relaxed/simple;
	bh=2OvuG8Y97nUFAd4jbDOAg12roAQyCXtpp4nP7ihxfGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAlQ5elhfdFk/m+k27J7vr74v3bIzDYwqWNmNYEVkmtegWIiZsWVQFK1GVgUlR/EsnTF/xRDYT6xbUuPTPM2vfpVz56NtFF6llzmzU5SIUWEvOAJAdoAsPNWbD2+lGJiOtPJs+Tf2BciWjpP3SuYqpS2XJUW1gbv73fkP5/+m5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=wFh8fH07; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21a7ed0155cso38688385ad.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 07:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737731318; x=1738336118; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=do/2ml/yvBUPKZUgX7AzOemseXMTNnJeFa62cp3MpRA=;
        b=wFh8fH07N0fv80x1lcxEt6sa/o+xV0yvYAmU7KNAwd2gr6++7+j9xWX+aNklHzaeG2
         nyx/u2OUSCfUt27afk78ziII4sHXuQ3/2+qSzyUcJjUrkCmPthZk3z3DW58NHGf1dMws
         RFVq1ufj5+9xqka1w1uXw/6teD92YxyAIS4JsTkDHi/fExSNt0qM/RNMKgYD40h0u5pf
         um10T4b1EA0jCn2QboylckmP2LIUEaRdzpNokbf20RPuTOBWlLLKp4T/TCPEZkmDriK6
         hbkxVXFX7lnL+eR1aW3UyCxooYBJzY6zAxgbfe8ElQ/PrIV6aFH2FvD/Ah1OHJyiVwN9
         wfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737731318; x=1738336118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=do/2ml/yvBUPKZUgX7AzOemseXMTNnJeFa62cp3MpRA=;
        b=KavkzLKbC21yHDpJFl8XX9FILObWVMWoyj1bgtoraFq8yitZA7//zEVJnpMo5JfEgS
         IOKKLehJ5x3/RPsp9cPuG72V8a8/UttuDNcsRQzuRv8CaBHlmJj8bCc6SJK2Xh/mu0Ht
         yXadaK2qZU+h0HXH/8iUfwDtTarHxAJwqjzGXZUSiRt//2T0C8R79g09NkK0viwLIaCG
         rXNlq0vmMsFOzmIIQ8IAlKvfqSKv4I2QUePbjPCKovCKjSYAW5xQ/V6VGmdIeNBai4nT
         93P2bOkblZQNxY5bgJZp2B1wHZLMODZxui6ftFb0o6dMQTP6TK+OUd/Dckf0wzJxOOAy
         fHMQ==
X-Gm-Message-State: AOJu0Yx2WgA6BpGIdaDjpMlvRdDOvdLZ7sQ5ClW4i+maAOxa1KRk0Xv/
	C/7VEpTi83jdTdi6vJlUpXgp/aoupFO4Ee+Dq+dykOSZP5srcyD8/tJEpxWw5TAuzEqGdgg3tyH
	RTII=
X-Gm-Gg: ASbGncvf7FCZjTM5Su29n+b2Bmz2fuGdTLVy77YDC1NBgqLr6a8yW2rKuDwR9RBkDB1
	0tos960yXKiwpgydN2q5VbYPZWnscfS3xPnMXKAvWasr7dSpxyXl4FXkOY/0TQRc1SHXBIVl7l0
	h2sv2c0tlItnPmKGuypcNUgdK941QoGwsKgCojg+ZJ4gMDXHHUxOyQKAmcsBgQXNjEG8KdszJFy
	PNStLsUa/EAHabS+9hHy1g744Xkimb4LHDZxdI0Bnz3cDZJcFmiFGw8slHhwsL9M/hEatqMDn3z
	6FZXkguVO0vN1FWbDD/fWhzRW1Pgu1zv2jHWqkI=
X-Google-Smtp-Source: AGHT+IGqKalsXDlg1G6q7KjhehIzDkbZTYUIiuVYkHdAJDSqBiowV3w2J8UbAstA5TunovuZ1Edr7g==
X-Received: by 2002:a17:902:c412:b0:215:7421:27c with SMTP id d9443c01a7336-21c3558314fmr485251765ad.29.1737731318123;
        Fri, 24 Jan 2025 07:08:38 -0800 (PST)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3ca7sm17297845ad.72.2025.01.24.07.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 07:08:37 -0800 (PST)
Date: Sat, 25 Jan 2025 00:08:26 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io-uring: futex: cache io_futex_data than kfree
Message-ID: <Z5Os6m-GLEkBRb8G@sidongui-MacBookPro.local>
References: <20250123105008.212752-1-sidong.yang@furiosa.ai>
 <a366bb4b-dd8c-486e-91b5-46dad940e603@kernel.dk>
 <Z5LppkEQ9tGdfwrX@sidongui-MacBookPro.local>
 <5bc2877a-7125-48e1-9dd7-6497c3bd5d5d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bc2877a-7125-48e1-9dd7-6497c3bd5d5d@kernel.dk>

On Fri, Jan 24, 2025 at 06:37:13AM -0700, Jens Axboe wrote:
> On 1/23/25 6:15 PM, Sidong Yang wrote:
> > On Thu, Jan 23, 2025 at 06:36:06AM -0700, Jens Axboe wrote:
> > 
> > Hi, Jens.
> > Thanks for review!
> > 
> >> On 1/23/25 3:50 AM, Sidong Yang wrote:
> >>> If futex_wait_setup() fails in io_futex_wait(), Old code just releases
> >>> io_futex_data. This patch tries to cache io_futex_data before kfree.
> >>
> >> It's not that the patch is incorrect, but:
> >>
> >> 1) This is an error path, surely we do not care about caching in
> >>    that case. If it's often hit, then the application would be buggy.
> >>
> >> 2) If you're going to add an io_free_ifd() helper, then at least use it
> >>    for the normal case too that still open-codes it.
> > 
> > Agreed, So this patch could be make it buggy. You can drop this patch. I'll
> > find another task to work on. 
> 
> It won't make it buggy, it's just a bit questionnable if it's worth
> doing. And if it is, then it should have io_free_ifd() being used in the
> other place that puts to the cache as well, to make it complete.

I found that io_free_ifd() could be used in io_futex_complete(). It needs same
routine that try to cache or kfree. Is it good to make v2 includes changing it?

> 
> -- 
> Jens Axboe

