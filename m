Return-Path: <io-uring+bounces-6093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69516A1A665
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25C273A73BD
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A7C8C07;
	Thu, 23 Jan 2025 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="EQcKW727"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B02B21128D
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644355; cv=none; b=nnFh/XM8xUQssp60Jf7apCAIYV6757UaVwE26IM8bnQ6V4PnHlUjfeQ7XXFVuO5ZB8xppl9AzKStI7AuNJUf/Cv40+jXHPOYHQI3GtKXZV4DTxB5zpjSyc4xPGeDgP6oHqTGjQMZ2QE1K5IBIl7/1Gd54+9sErzXts++TkHFfwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644355; c=relaxed/simple;
	bh=z26xlDKgvZKtW8xFUP//1YfDYaLt8vBs4G/b1DE1BMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXhjrex49nBcC0Nn1ps5H7PqEcHPcuUDQ/S4PVFPSaHL7OU8RPqLq6QkhkU9wEaBDSRm1SzW/MVe5Ulu7kRbVBYuqi4o0oCBweEkEZsxlKi9cSg1sktvMDRApMi3+MHT52e8rTnI7suwy7SBNUfFH60/geDq/qHNGKym0Yuq6ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=EQcKW727; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-467a3f1e667so6133561cf.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1737644352; x=1738249152; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fiyNvYzvY7+Pwcm/ebtlPGQx1xTMZdiGPfoYmHfCncs=;
        b=EQcKW727kin45K6MXpLjdfmWXkIl6lUu7FskUWIVzNXS2tWSOUfYRjbLW20hGNzhmX
         tzKS8ndsxxQLA2TD1HGDavMdowuuAhM56rKdgp6ywuMo80jWFxJcQvDGFKeLc7Pl81jO
         FRVRaqxjb7LWHjUoC5d+c0+pRu0rLiT0HEQeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644352; x=1738249152;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fiyNvYzvY7+Pwcm/ebtlPGQx1xTMZdiGPfoYmHfCncs=;
        b=OQ9X3FXGvLgqYORSVIEJIbUjyn6AH/CeZ65nCXS6n4RrRwZ+Jv8zFhzofsWZ0oU9Ag
         aIXsqiGrQ1uFa9gO5URtzvk+svF/DiKTP57sb2seTHRqVb6TiRUcmT57Nl328lM4iaOV
         WHac5XrkBvcsqzqxQzbGDprGEjWo/eplqpjNqzybqGP46SEcy9Yc2r8dQwaXa5bqJ+GU
         mrWnNy1NbummNMDQ9cCGHNkoQRETNn5YX2C+vRuiS160YgPEeodKcL5ScztNcrhk0Zql
         u3oPYs8sWv3bgsn00IvuTN61UD/Q27Wo2Coy0iRtfhySeqyh+q4lkycs/ertSXHUeOny
         RkOw==
X-Forwarded-Encrypted: i=1; AJvYcCVMPhWyDMa2Ts6sN34CInRzpG6Bge4cLzRs6QMLH4/A0Z8qTOgsX1eu8dcUgMgr7G3l6BTxyqctVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZkewpgwhA8iESRBlKrP+WLCuGGAiqSuwwx5HUX7tOZK1M9/Zc
	X+dNAABLu2MT82KBu3F/lGvK+w/W0SlMuB+QJdL+6tPiyOdr6IHVTwpKZEnSpHLIuWwTVq5ur/F
	wScpbPbjzZwGhhj6zj5C9alD783MHM2VYr9cYcQ==
X-Gm-Gg: ASbGncvTPhY+k0NK8jUJjVs5rMZzX5SQxTHPIEcLeP03ePQDgm5kD8MBTrydKoY0nYG
	xxTyuRJaVFqYB/GmnXwOiSPFx1KEWDnNiy/xgc0Q3uE6zzPppvaFUsL6da7/WafIqTAwMXMA=
X-Google-Smtp-Source: AGHT+IGAxRTvyq9Qh9+hNzJteVyh8T3Pgjt4r2NQHIiY+TXFoZjWLamCCgorLYlkp5a+33J4E3MmD3iN0YOW2czaYU4=
X-Received: by 2002:a05:622a:180c:b0:468:fb3c:5e75 with SMTP id
 d75a77b69052e-46e12b688e8mr372922561cf.38.1737644352481; Thu, 23 Jan 2025
 06:59:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com> <9516f61a-1335-4e2b-a6e7-140a0c5c123d@bsbernd.com>
In-Reply-To: <9516f61a-1335-4e2b-a6e7-140a0c5c123d@bsbernd.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jan 2025 15:59:01 +0100
X-Gm-Features: AbW1kvZxir6v28FyzmjhMPKyMd4bk2rSjT78Jr9fN3U-UK1SQOLnPbhmps_25LI
Message-ID: <CAJfpegu0Pyxo3qLHNA=++RHTspTN-8HHDPNBT0opL0URue3WEQ@mail.gmail.com>
Subject: Re: [PATCH v11 00/18] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>, 
	Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, Luis Henriques <luis@igalia.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 15:53, Bernd Schubert <bernd@bsbernd.com> wrote:
>
> Hi Miklos,
>
> or shall I send you a fix-patch instead of resending the entire series?

Yeah, you should send incremental fixes.  Much less bandwidth that way
making review easier, and I can still fold it into the original series
if it makes sense.

Thanks,
Miklos

