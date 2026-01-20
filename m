Return-Path: <io-uring+bounces-11834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 939C3D3C02C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 08:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4C520401D0D
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 07:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA01378D68;
	Tue, 20 Jan 2026 07:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJss081o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8447437996B
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 07:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892735; cv=pass; b=OT3dp1NFJVjUWYD9+I6PN81X8A3gnnM5YF2VqQPSlNP22iX+HyGGof0yCgFPe1tiWWDGnB599ZwxR0qaa28BwilkDAhFjNshaAdX5NX3NoHS2FyD8zdPKozumbM4hMun3BXBXfShQQoIURi2HnTibQGGtYmDc0fd2OvMlp/BXAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892735; c=relaxed/simple;
	bh=7u3LFKR7PiJpIeA+QR71UF/La+iD1BubfJTWEVLv87g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TyuBhzKkToN7AnksPm49L76oJnTb0cuzl/jet7MS9dCQu8Czy5UVOWiCmQkmOC93erQZF/wL7uUm4mNo5oBpXMky8z5bDqj5y7HuW8zZkNHADH346jDhpXL19uZ5uhjdm+mXoiQ9kRA3o1u00QLoMnZcr1wzeSJWOA4HL4W41pI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJss081o; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12448c4d404so3841994c88.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768892726; cv=none;
        d=google.com; s=arc-20240605;
        b=dr+ZKmwTe72+HHFPfF3t86gv/3ane7v+mC2cyTPsRZdKaHINqnqR+wjNg92NelVtgo
         tei+C9nZNa+lpTPgei0ugcMfrLIfnT8vbfIOrYBkkggt9QLuf5jQqQvLHPmjs32+Z2G5
         ckVovMiRVeqcbidZ3Hrs2A3AzYKgnGmB1x+t+QgpWI98O1lYoBnH2vIB+dW6ngkRyL1U
         rxuksUPr9I45rXlINY7J0CaKC9+1hK9E/lfMo3dqACEgyjDFmZqVeZ4lP7AkpXBIoXt+
         ktYAPwzfxmWQnXVeGMlkJvIM+FogGXwlJ5UPjw0BIlCBfRTupYtptgX/wKQhccWiJCBT
         Uh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7u3LFKR7PiJpIeA+QR71UF/La+iD1BubfJTWEVLv87g=;
        fh=nGcAi9xKv6WhyyH+zZ94Ore2+mtbKCq5kri8KvYSuuo=;
        b=YmFqxljeCfqd9u25qLdXf6c1ZdGcjE83qnjf1Lthtvqp0uNp2Tosi2nMInax1lbgY4
         3Ki0+jQHvOFKok1t1kWbnr7xTnJtrvNcAApXBhIWqNXTd2GM5uMXSi/hxHyk50leL7Lo
         GxKZMqr/y02pwxv4zansdAbNdvmZSWSxQl5mUwTNsBrzP3DwE2LF+TEp1iFga8PgDaLU
         FWsZ3LB3d/Xl8SFLGUrQJVswn6iM4a6dCE2tanS32tmkZ3UFU/UCOfYiBAl0Ge50PDCs
         xVl/Im/1yq9tHz7/lUe488pUBaAVgzpqz3eZSeV2ra5iMOBEdyWuadIeX2/uiSMEnKWz
         WjOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768892726; x=1769497526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7u3LFKR7PiJpIeA+QR71UF/La+iD1BubfJTWEVLv87g=;
        b=GJss081oG9WQMg62peZUpGJ48ed+dxIs3wbhhi/P7JPikEqK5ABWSjCgSsimnQpNFM
         JDO8u2JY/31brT1GyqmvftZZq59quJH0GS5JnU70xnN/DrjffBt6qbC9D2ex75S9Fs84
         +sKFhT/+OAsYyjUPXByYh2CzwpYfByxIRux5NKpNq2PynK9epxlNJnRFUeR9wijMGnhw
         ASHLPaAPhh5Y3UyqQ2R+JxznKU4FVWJmp0J3j51Y00UCifzuDBU7DtJTexSrBrRVo6i7
         66O+BOm9RsPDDIIiQj5EFpX49ggPHNM9LwM2jSHxPi8sU/CmnP9w59fuVXQy3ewQ3Yy6
         ezYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768892726; x=1769497526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7u3LFKR7PiJpIeA+QR71UF/La+iD1BubfJTWEVLv87g=;
        b=nDqEgDrfVv5OQ2QmkFA7CWEbgWgRr+ACYUmRzdO2pfFQW8w+eDObhGBeNptUm17obT
         Yo70LSlX2SRN4ku6rkzUefUPWRO2+jI1RTxYkNk+vfM4LXMMxxsPx1vVdbtD74KCM5KR
         HHgZBuuFGPxee+Gt6VLv5PEtpy76KUUTdkLeWn0QjOOLJYQjavMtv6xVAx+iLpQGBXCT
         cjbAqimdIUdqUB/9iKhRNBE6uyhWnhwcNRC8nz0eh52UdFqi6kKBt7zm6O1bCMMP4Py5
         g5V8/o7IQgUB6AcsOptnfVXdAAnjjp8qt2tUexrTsn/QoDaIB65oETDP1c+NxcI8Fikp
         FEjg==
X-Forwarded-Encrypted: i=1; AJvYcCXdsjKjhonnOkf3xDe7Uq0INaD2RNmsEXArCy+Hx6Q/w4G9b/ckA7LJRefGUvGdwhMwJuVvQ/KKfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YytpGian5qJIuJzc9vkw46yQOCMskRwUPfASzja5oBCoFRmPq7V
	NO3vSgjtsNCLAUQN+zo1iO4wiBzdD6uRwwLO3BN63nXHVQ7V7R9Cb0yhCN11TqdFnOMs1n8d+hH
	e1kJLZVV3X7mU9Qp+l1FXLHzx+MOS8gc=
X-Gm-Gg: AY/fxX4W0t+hnmkpcp149bugQzAt7spbcYTpy92/gFabaQ6TUUF/gzJ6JP7SO8mA08I
	DJLHEEJEMzYHinPJvTk1BZFnVjucVYyXKssI9vUrgNNNwaY+/EsTwvQWDUaDk++kbhbhL6B3+kj
	bus6NQedjh1nsEK9kB+rj2T69z/pzM3GxuhZoAxOZMaTZsqZYYYe5smzEkjA2kF91EJQx4s1qqn
	sm0Yp81Uo7E7ByeikqJkP4nMChNStcUVJRJu9JllSARytbfFcVqVc7V2J09Jpgt9Pq1uxoL1B31
	ZEEoah2B6xN2FeXZFEKlI9T8xsw=
X-Received: by 2002:a05:7022:4394:b0:11c:ec20:ea1f with SMTP id
 a92af1059eb24-1246aabebb7mr790262c88.33.1768892726001; Mon, 19 Jan 2026
 23:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk> <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
In-Reply-To: <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Tue, 20 Jan 2026 01:05:14 -0600
X-Gm-Features: AZwV_Qhjs1DeQ5q3LqpnpDjn-ntJzACaBKK4Zhzd4f51YbjZA3cWNbJGpFmWlo8
Message-ID: <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, Jan 19, 2026 at 5:40=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/19/26 4:34 PM, Yuhao Jiang wrote:
> > On Mon, Jan 19, 2026 at 11:03=E2=80=AFAM Jens Axboe <axboe@kernel.dk> w=
rote:
> >>
> >> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
> >>> The trade-off is that memory accounting may be overestimated when
> >>> multiple buffers share compound pages, but this is safe and prevents
> >>> the security issue.
> >>
> >> I'd be worried that this would break existing setups. We obviously nee=
d
> >> to get the unmap accounting correct, but in terms of practicality, any
> >> user of registered buffers will have had to bump distro limits manuall=
y
> >> anyway, and in that case it's usually just set very high. Otherwise
> >> there's very little you can do with it.
> >>
> >> How about something else entirely - just track the accounted pages on
> >> the side. If we ref those, then we can ensure that if a huge page is
> >> accounted, it's only unaccounted when all existing "users" of it have
> >> gone away. That means if you drop parts of it, it'll remain accounted.
> >>
> >> Something totally untested like the below... Yes it's not a trivial
> >> amount of code, but it is actually fairly trivial code.
> >
> > Thanks, this approach makes sense. I'll send a v3 based on this.
>
> Great, thanks! I think the key is tracking this on the side, and then
> a ref to tell when it's safe to unaccount it. The rest is just
> implementation details.
>
> --
> Jens Axboe
>

I've been implementing the xarray-based ref tracking approach for v3.
While working on it, I discovered an issue with buffer cloning.

If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] =3D 2.
Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
and unaccount, so we double-unaccount and user->locked_vm goes negative.

The per-context xarray can't coordinate across clones - each context
tracks its own refcount independently. I think we either need a global
xarray (shared across all contexts), or just go back to v2. What do
you think?

--=20
Yuhao Jiang

