Return-Path: <io-uring+bounces-8043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B8BABACD7
	for <lists+io-uring@lfdr.de>; Sun, 18 May 2025 01:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6271898F8E
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 23:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C4D1BEF7D;
	Sat, 17 May 2025 23:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EqR5CFGN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0574F1B85CC
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 23:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747524537; cv=none; b=Nr8ThvYESp/yQ6kqGDnhGgUaY8sfR/yJwj3+G9b/BeH/etLI6PH+xg18CIQ7ZfkxHWG7vm4BIP7aE/MxaHvexsOFiXrV50u0+jQjarDxBMqet8N9gKsRdUh0R75o3eswJ5WCnm4CsTfPb65Q7EOlsRLs/6fsGoQzBjcxL/kEEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747524537; c=relaxed/simple;
	bh=7aogNg/azqstKXt6vbif/vRc3yaPdwvSjADi+vGQj9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1RXHfzYJnaI/KprULlSRaRxhvMp9CaZn7mqLGqgXVdL+XIn6ZDB4m8MSeRbSrDxqp4VDKk00CN00bnr6lYsqXk60YlC/W3E3rF/582+93ACFZiTkhOSybQRXi7F+4foFdz3DIuJfmUVtKn4t7TQtC8oeeR03K5xtKNOA1EYhLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EqR5CFGN; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-30eccc61f96so98384a91.2
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747524534; x=1748129334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aogNg/azqstKXt6vbif/vRc3yaPdwvSjADi+vGQj9Y=;
        b=EqR5CFGNhyAIXlrpxTAuizTl6yqvSiLH8a3ao7/KZ83WqfAAnv2eNv1JBO5x9FkTLe
         BRaNCiCmKJJMNtBGdvCNSG7TtYEtMQAYwrqOW+H7q3OtXcWowAwTVU2GBOx2QmJNczsU
         yRhPTF9JHKIbz42iWwtJPAyKpKcNIKciefympScFBYb4YJGibzZ1L7lm8y/3uUDa/ZAI
         Q93VchC+DcYKUMnPxwteISdXQ+3+Dpd0w/p9p8N9+jp4+HqEJTI4xVYqRYJtqSTooRMg
         4ol5VKpj4yu0UphU8JvkL7V2BJrmRD1qmoV3q/B5c2Kii6hPvJJfvQWsoIqd2B82Tc/q
         1Hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747524534; x=1748129334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7aogNg/azqstKXt6vbif/vRc3yaPdwvSjADi+vGQj9Y=;
        b=ieCZ2mDVTWhYMTa+vMHvE9xxDUL7Rzo4TzKImuqwr1/Wn163XeULfEHp0dfSP4Sary
         Sb56/eROAV/rXXT3aGf2hXvKUxWLryowZOroW9XPBTatyrdXbvTFlc8WgqF9mS/xsrGt
         xX7mBGrbkLDwJi0dkPCC3Q5dAlWvoAWJxfbPbr6DsWwg3FpxpPtAP3df2GMy3v0Xa9UU
         XrzWlyg/qxJmQHqVsOxp+T5ntMLA0sFagj4xcH5ZbCXF41sIuwRWqHy6XWTy8VTDFQS4
         Ad5xfxq52I+XdifbxvpqUgWPX4M2Lsi83LIJwkkuXEN9V4/Pd8b14PYbsrmpYOy1pJlx
         LBxQ==
X-Gm-Message-State: AOJu0YyMGG2kTsm/0EC/tkaNyRpZhceJ1ESgK6rx3VDewiWHJWLIMahD
	BVMDpLWnodwY6Gwh87CsCdLSpPnRzTj3fEfSDANnUQV6ktAo6+Q6B3zX7UFK+RTWLS7w2jcowJ0
	QtG3rCZvLf0NES5YkN6GIsvyQpGBTekoOTEhrOptDMGaACbzKjphiamORLw==
X-Gm-Gg: ASbGncvqjRbdtpmodEClb1bv5RcFPEknJM9VPLshiDdYh6z/D3rvyUIGBrJ9BIbel+O
	NuAavDvPIJD0X3y0DEAaiYW6AY0DWk3usdjrVSy/aM0TP1AXipp2G1+AcAGQBxm3/j7UZN+ZNru
	N1Vd4GXRC/x8G/BtYfYt/rcWepU9Hg3bY=
X-Google-Smtp-Source: AGHT+IH5mMCCS3Y/onqzjY2g3rraZ2Fvwo7ETQ73eIGxilaskIxPUDtF+/1S84H1ZcPweAG/piSfuYtDBp9cVnT/qY8=
X-Received: by 2002:a17:902:ccc1:b0:22d:e53d:efb7 with SMTP id
 d9443c01a7336-231d43a65dcmr44861315ad.4.1747524534200; Sat, 17 May 2025
 16:28:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250517114938.533378-1-axboe@kernel.dk> <20250517114938.533378-4-axboe@kernel.dk>
In-Reply-To: <20250517114938.533378-4-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 17 May 2025 16:28:42 -0700
X-Gm-Features: AX0GCFsPddHMa5-bYekCjL4SiPfqFJSvAIxNX746wlCr6OQnlnVH2rm4bMnoWeg
Message-ID: <CADUfDZqLYC5cLFU2uBsRQzqRZgXL_MnS7dOmmu7wNKF3-cfxJQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: make io_alloc_ocqe() take a struct io_cqe pointer
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2025 at 4:49=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> The number of arguments to io_alloc_ocqe() is a bit unwieldy. Make it
> take a struct io_cqe pointer rather than three separate CQE args. One
> path already has that readily available, add an io_init_cqe() helper for
> the remaining two.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

