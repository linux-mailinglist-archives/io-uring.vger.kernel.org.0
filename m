Return-Path: <io-uring+bounces-3734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D388F9A0B03
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 15:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AC571F265AA
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 13:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4035D208967;
	Wed, 16 Oct 2024 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hnwXyZaZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D381E206E66
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 13:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084097; cv=none; b=CzKoxdFcFZtv0hxyPE+iBa6HqgcHDZAWLqA1huGFs7sr5G2IeXDY7jO9arNS6lZwOCZXQXV4DPlTmODPiZ0OVdE+gSwL0Zr3WJUG3RAguzMyVsu2hmzBv9G03dkcXUDjCi3OIeWNkFwLto7wEx7Fw0l3Htv8nRa/Yj38e1OL73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084097; c=relaxed/simple;
	bh=WyGvV7Xv2ylVnIXjtub6IszMVIkGfcc1fKl43joFrcs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nq95RMHzPBADII6tir/ZyhoHhECX0dDE8OawV4Wu1sDzh9MU+3n/p5Aku9hrQZH2lOSZMDshu15GbTdNNyo0zpGnV/TR/l9SlOpTriBBw1yJKeCAeijSZIXi0jKa20JmNEVWGFsONhamF5qyLfkyoCf/TOBDnP/ZIcHbRKzaw7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hnwXyZaZ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a3a7b80447so24351205ab.1
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729084091; x=1729688891; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sTUDHyUYFYBhvZ0huetGY8YV7lhoS19c0DB5rIA2fr4=;
        b=hnwXyZaZ0ohODwDcNjb1Y+Re5H2KTjPtWm6zFpilp2SXj89lpVCVpnOKMLxJYizZKf
         +UYPEVRI7AkK2/l0Mt+I4lWih/B2uXrnO14/e1tC0HqglH3MG29UiMNiJN5e5FrYCdf7
         v25hzsqVR/yH+TXLHacPHSLIZ/kPSxbci+UZA1q6mro2CUjH2qEtvIkVj5LXUi9JR857
         U4QVgMzDfbPNEFhzjNEdyJY/4DfGkx6yfnzQyA8X/dsw+k0MdaX3/VEwx+98IUpj4yTO
         HHzB50JjYSuUpSu0WuhI+LGrGNVqScdekSnCdOK2unaJWbx++2KDTPk1f+Qui7Qdy8rq
         kkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729084091; x=1729688891;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTUDHyUYFYBhvZ0huetGY8YV7lhoS19c0DB5rIA2fr4=;
        b=t/CH0uN+LaoTY3EniJzQAFsq0bNmF4G1UHHjtfTAqN7KVZPPHX/6RZU/OyAVrnymzO
         4rcdCqC/9Kzh6fBv5UF2VAR12HLmyxEkGLJSyBK6C18Fqjqzt1wNuHBVe1h9XAgBC6E6
         CzFqwTfL9YpChtvVwT+5gkp02iHGa78OCnnm2OpBZ127vvXQLlyjPjhOHKFkYJl/i2N8
         Hc80xiqBr/gpAYmF3NYUvqx/3LnZIiBYF+PKYIjwFboaRvKkK0slg1Eua+y7HQa0cWbU
         YlsaCtCOPgfFYPCu3LwNnjqzWtzXHuLS2XGHTOrhebZ3H3bH/gel1kEXFk+wSZuO6Zz4
         jAfw==
X-Gm-Message-State: AOJu0Yzh2JTU60Z9x1gejVbbclMgINiRYRNqmC6NA/ZI3IwpNlfkXiC1
	3CsBCYOwcyzxDpCpl659K4cdOH/BZVphZ9g8raeQQkrCZNb+oLD3m/nM9YVaFknZVKy38sh6Vok
	q
X-Google-Smtp-Source: AGHT+IGDuhhMi6V68qmfSKvTOIjWr4GNR/JxMcLSEmMgPlj+Re0C/J4zXGo6GDm4TscdH3bryQF06g==
X-Received: by 2002:a05:6e02:1705:b0:3a3:b256:f31f with SMTP id e9e14a558f8ab-3a3b5fb60cemr180799415ab.19.1729084091247;
        Wed, 16 Oct 2024 06:08:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbecb3aa3bsm780164173.119.2024.10.16.06.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 06:08:10 -0700 (PDT)
Message-ID: <5739f382-5a94-4428-82a3-5271afd26dd6@kernel.dk>
Date: Wed, 16 Oct 2024 07:08:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: rename "copy buffers" to "clone buffers"
From: Jens Axboe <axboe@kernel.dk>
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: io-uring <io-uring@vger.kernel.org>, yi1.lai@intel.com
References: <27e7258c-b6d0-439c-854f-e6441a82148b@kernel.dk>
 <Zw8dkUzsxQ5LgAJL@ly-workstation>
 <b197e714-d117-491e-83e8-a6849e027e8b@kernel.dk>
Content-Language: en-US
In-Reply-To: <b197e714-d117-491e-83e8-a6849e027e8b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/24 8:27 PM, Jens Axboe wrote:
> Thanks, I'll take a look! A vmlinux would be handy to have, in terms of
> looking up where it's fauling without spending too much time on it. But
> if you don't have it, no worries, I'll give this a spin tomorrow.

Ah, it was just missing the dummy_ubuf check. The below should fix it,
I'll queue it up and add a test case to liburing too.

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 33a3d156a85b..6f3b6de230bd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1176,7 +1176,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	for (i = 0; i < nbufs; i++) {
 		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
 
-		refcount_inc(&src->refs);
+		if (src != &dummy_ubuf)
+			refcount_inc(&src->refs);
 		user_bufs[i] = src;
 	}
 

-- 
Jens Axboe

