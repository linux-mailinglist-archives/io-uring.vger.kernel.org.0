Return-Path: <io-uring+bounces-8281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9F7AD1415
	for <lists+io-uring@lfdr.de>; Sun,  8 Jun 2025 21:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C233A9A97
	for <lists+io-uring@lfdr.de>; Sun,  8 Jun 2025 19:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63D9165F1A;
	Sun,  8 Jun 2025 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RsJ5wHYz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D56916132F
	for <io-uring@vger.kernel.org>; Sun,  8 Jun 2025 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749412695; cv=none; b=j3/zZi92LnlTH6xG1sY5nfnzGT/FasRwlbgYpBVmkw+4z5K7hiWqngonppPMsNBQXXFKp3+L1Qqnq8dfyLF+2aGa+b74CSqPgtXHpipHCkwAJX4AiS4uhDosZP81ZeQuZVQMC+/Z02Is+mls8aixdfgo+mLn7zmJ5gUXMF9LMvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749412695; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPhruSrPk5rujrmyOJnF1FC5ii+FZhDebdo6lC8NFCzFRBIGKl8+1kqdK8dQJXWtLvkZALcdz4U9aBPJKvrT2xxu7d3QrLQxGuIndQclIjlAxu6czIwKuk8XVgxHaOs8Jz5kGgL/LxJd64qtzHppowzgJ55jo4QatbTXEbZZmOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RsJ5wHYz; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-607434e1821so3793685a12.0
        for <io-uring@vger.kernel.org>; Sun, 08 Jun 2025 12:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749412692; x=1750017492; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=RsJ5wHYzuH9PTuKtDguIMI0n1AfGXim/Jus32s3h3oBfA8WU2zP07agtVrlEay2KFx
         TFYxGYlt5/Q9eG4tcTW1+AqOBCOLwqfNOaC4/6miWlHpto5GpNftdMyu+TrW5Yb28hyN
         rqChEMGh7/QBnSifvnl9Muemzsg8rQ5lZoCHm4M0Mhn8g0Ipug9cNGJC/us+WeOhbmet
         HUHZ72+PP+Po5DFRca2RpesKEE1auIjbs3Q6XIo6cg+9/+mrv+AVvBxuy6f4bE9yQN5r
         fDyUsW1j/JQVerWPZ1W1MLH6m5Bqq5CjTIO/CtH8gC4JJaTwNS9pxdzZ8euFP3FjVJjz
         /aLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749412692; x=1750017492;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=o7LPohu9a16iALINuqkP0Sr8bSC9ptABRFmtz6sOBcJYzSXms6ZNo9zeVobyU5ZDxV
         7/62H/EM9lQtMWcf3FqW1tkxf5pwqlECL64jdXJmen+kFqwH5XGspU1T4hbr4NLwH7pf
         eGQPJtF7gFoQvtkCof46ZMug2Xqe1W4aczqt/s2MVcZjeCx78KyaboDopZGBwKWRTW47
         nodvMUDnyNFw+P6FKw2AqGw8842lItUoILfkl8+EVQG96My9ACS+j2pbIcz/pjWFz1//
         wVtTvBk2J0iUZew7SXG73ODs/A0hwIXOaw1uauLmUnxHamdyX94Csu//A7ey44TywEbN
         +joQ==
X-Gm-Message-State: AOJu0Yz9IqDVXVePwqD9r//CRjQpMtUyI3IE0XfOTN1s3MFU0haSDjdP
	Cc77Q3+G/uORl6hLb0l2tRXca8d/It4nXMS/JM+wAU9JgRtYK+JUT63wXFA20aCivtbeFK14qt3
	k3H11r4oSucAQKWbXMhr2li6+Oj74M0me9YV3qjNO
X-Gm-Gg: ASbGnculpPz1APVbmO41djhAMGFBeSxZ7zBdGBkr3Ry6Jo9Y3UExJyfDWubafGD/VuC
	SDPFyQrrbJINu15g+HOrekqv7OOJeoFoXW+xbvs3n4yGfhhk66CLwCTJLB3EAR3ddMnLVkNAbod
	eHs2aKQjVb1pkZdjyXd3+lZZXxB78ytR1Utv4vYsM2yXConfi7OlvqVzSct2kFfJ8=
X-Google-Smtp-Source: AGHT+IHg2qai5Z5zTyWupIuQeSLbFWpkObMn2mxNbIo99OIDR7/S+k22f/weEEuWM57fa3/Uu/7vnmrODnMwySg435Y=
X-Received: by 2002:a17:907:c22:b0:ad8:87a0:62aa with SMTP id
 a640c23a62f3a-ade1aab90f1mr1074788966b.27.1749412692208; Sun, 08 Jun 2025
 12:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606215633.322075-1-axboe@kernel.dk> <20250606215633.322075-4-axboe@kernel.dk>
In-Reply-To: <20250606215633.322075-4-axboe@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 9 Jun 2025 01:27:34 +0530
X-Gm-Features: AX0GCFvftffipWVQu5yGTYGSpC1KgWk5sszS_gDtsOfa5TF6QQbIU7u6zbLxz6k
Message-ID: <CACzX3Ave=aqgaED2NqDiC7cdh65q7BQwBcCrYjbSkyKY3+ijzA@mail.gmail.com>
Subject: Re: [PATCH 3/4] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

