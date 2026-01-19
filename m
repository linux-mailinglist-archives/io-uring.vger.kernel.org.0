Return-Path: <io-uring+bounces-11821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E51D3BBC9
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E62CA302A392
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9C12DB7AF;
	Mon, 19 Jan 2026 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mH6vWDt3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429462D541B
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768865696; cv=pass; b=J30gBwRT1ijfuQtMayCjURN2+tZD/UBIe5iu2lz/cmCvEqeVYhB/YvG05Qo6RnXJUfoCWi0M21dZRJWB76E1KOxA8+MqtebUgTIg/Z2dYsuwysQpdOju6yuCh5ZyHTufIFQAEDt+loWlJp0WLeYe1zG/W9zLJC87XWd8x1W9iT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768865696; c=relaxed/simple;
	bh=ZZ3bHuhkIR99WX0mMtcMVkbpFCn0Hj9dtyBxtjPmz8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J0KUt38Zc64eautzZCZX/Ec81qNlYUDgBPLqc3HSMVElIuTvsXMbUyx+yIPqHvNPqL8cg2+KL+o5opoXXHonX2R2Uk+4SMcQKK66C3MVAZTzGVlkUhcCFmhKzf0TTs4XIdv1OMin9PPVg+94bcFsXUnSYUJK2Vm0AYAtASYEjlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mH6vWDt3; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1233b172f02so5930636c88.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:34:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768865694; cv=none;
        d=google.com; s=arc-20240605;
        b=hDbodUfIFDvI7qDftFR4FOGu+LpKCKBcuf/zq6LXJ5B72ou0m/SnlcExVCwQ4zqiqY
         rkclPHMdmqFjgUIk5O+bWxYimTzfE+l57fkxMfaL0CI02W5NW7t9G9JmsdXbcb1IH8zK
         KbV4I7A29pBQk+7NhbEhoMt1p6YViTfUDgDnZvB4+jT5D1f73wMLmPNMNJ/P4rueF4BW
         ozAUI8+M9acem5tOFsYxgipyQ3m1TbRg6VQIK+NX6y+4E6gz/NkBnxuI0hUsB50JQvdC
         62psDG7SxcNyHKY2QdM3dsxUEsG4soUOWqVUDJUMSiYYDXIsGGDji5sTsPHDR2fg5gEi
         /kqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZZ3bHuhkIR99WX0mMtcMVkbpFCn0Hj9dtyBxtjPmz8o=;
        fh=Aov67FbCPoXVatdCrd41x1qHUIjikpMZUEhwhYBzpjU=;
        b=gRFttSbn+/ymfvHPK1LfMhXbVHPjg2pw3Gy6z1742c4ztd+T5BIF1KXJJOzXqnbUII
         2vhbsum2GLs8kBMJsyZ1uidaMnVKcf1T+fv2tLgXSEyBFgcQdR37U/MXtnOY2mraJMmj
         QyHnENOlH/cSR90cG7xhUg/k+OXRSmxOKcibHDNH4D0MW62ll1JX42BXiFFIb4v0Hvwp
         D1S/CfNmyTz6k3wkYOBI0+cAEwBYEKKOrA26y70zBMcuaqA90kij7+fKkwMEUsvbOY9g
         KlyQ29pRZduo0lFhNbPNCM4ARavU7/77EuMgOMcMJPtIciZSojMuUChIMlOdXqaCM460
         wyMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768865694; x=1769470494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZ3bHuhkIR99WX0mMtcMVkbpFCn0Hj9dtyBxtjPmz8o=;
        b=mH6vWDt3ocQ+K9Y7ch5dtPt5ZunVJmaBiuvAdXA7Ouzp0l+Sd81SNh+KcJwYVw0CKH
         ynWyoQVwKLmWqV4H3Xwq7cfsl86SrszM0KX8JbXPZwu/XikdsnHTANt7bV3meNyOjSy+
         WsJdahH5tGdlHe2sgFlZVmEuPKBXc9/WPQjwS+MVoYicOK4xqyJ45xvLXkPDLiOavtWy
         MwgM9J52RbzFqqDIfHAQFjsjjesg2IbmqZh1SKqJK5iRXyrGM6euUg0XzovN4izDsQur
         SF3mAqZImOdP5BaJyyk6eQWWf6Cu2u/LoRQ2A/kcZ60HR8BtbmO4CkJnO8BxtzoraPBS
         HJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768865694; x=1769470494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZZ3bHuhkIR99WX0mMtcMVkbpFCn0Hj9dtyBxtjPmz8o=;
        b=R/UEyU+yV99YOZGBmc9dtCTJ1rmpQjQXN8XecsRuy3rADUQJJvTwACs0hs2MAFq1iv
         eOn7qEz7Sy7ipzs3TqRUSBTCIf8gFlvmnDSQbXxlVOuL5RDbjHlV8YNlg2Kht9qrApr1
         sObKqMqkVUtWtxfcx8Lsao1Q2eugvvWc96S79lj2ECKDKtOai0YuOb5i6pUQDB+nHfQK
         e+gIdsg+S7uaub3F4YsD2IBjGz7Cax9ISpwNOPa46xDej3iLdQzgkDly1saBBSsUbJ9y
         mkJOEhhOKKdAbnxABdj/6FefvslJZ7LJ4mbE9orxaqyyblyxdP0asMEUlHpYcSztf5y/
         sNDA==
X-Forwarded-Encrypted: i=1; AJvYcCX/q62LfvCa+LE0mUxbezEa7FOHrrV8O5PfNUbukMqjJ7auF9JV45y8MQiAA4Nm8at1WT2uWip3+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH2QVlSEoW7izfWw7sUcgIyLB/UBPzzRAqiAu8WVuRD4fjX044
	suf5j1zMdl16XqZd1CcruHJIniG1KsCYSqXYCOsgY3QSm2QQbFV0YA/Fn84um33WPnJtGQrf5/E
	1ooqJYgq4oEJpJ/TDqm2g0FeXqI9vItBAO0Qq0SY=
X-Gm-Gg: AY/fxX5LkhddqruoJHnv85WUk0KQJlIp0fYW9uOeBxKt+LQ0dF6VSyvH/5Hy1ZMtB3N
	pUfey29NK4S5R0kpQyHp2Ufx0u7hVXmZlNRQMK4Ao+0OdO63cHQB+NBemdM2UBOEKRJ1UpM+c53
	0wl+td8NyQENFTpVg4XxBfsV5uFUEOO6RsOQTEGP+hEwdEEeR/7EyXb4LNIum66LYYybbazLJpI
	5g9Oi1V4ZWQcYh6TqedCB3BZ/Dij8wQGDAXH3FZCfsy5xI1trB+z99RHngruvSjFzdgJQ0XLwr1
	FhWEg71XCinpeu3w+Mk+Hud8KTs=
X-Received: by 2002:a05:7022:eb46:20b0:11b:95fe:bedf with SMTP id
 a92af1059eb24-1246aab3428mr65745c88.27.1768865694289; Mon, 19 Jan 2026
 15:34:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119071039.2113739-1-danisjiang@gmail.com> <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
In-Reply-To: <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Mon, 19 Jan 2026 17:34:43 -0600
X-Gm-Features: AZwV_QhrkvTrXYGNnwhF1DWukVwYJ8GmYYaxLKmVuQL8w42ClSQRPQ1oHjc-dFY
Message-ID: <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 11:03=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
> > The trade-off is that memory accounting may be overestimated when
> > multiple buffers share compound pages, but this is safe and prevents
> > the security issue.
>
> I'd be worried that this would break existing setups. We obviously need
> to get the unmap accounting correct, but in terms of practicality, any
> user of registered buffers will have had to bump distro limits manually
> anyway, and in that case it's usually just set very high. Otherwise
> there's very little you can do with it.
>
> How about something else entirely - just track the accounted pages on
> the side. If we ref those, then we can ensure that if a huge page is
> accounted, it's only unaccounted when all existing "users" of it have
> gone away. That means if you drop parts of it, it'll remain accounted.
>
> Something totally untested like the below... Yes it's not a trivial
> amount of code, but it is actually fairly trivial code.

Thanks, this approach makes sense. I'll send a v3 based on this.

--
Yuhao Jiang

