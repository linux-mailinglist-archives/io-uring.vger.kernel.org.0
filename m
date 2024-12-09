Return-Path: <io-uring+bounces-5353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 554A89E9D9D
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F7E218809D5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DF2155327;
	Mon,  9 Dec 2024 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbFXusl9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA9B1ACED0
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733766792; cv=none; b=Z1oOcWrrmDrlkq9FqhKhD9TwLoMQ90boWo7IQmSHQDgLsf7Q2SRzNPisZfE6f/YeIG8hd78f513cHRH9iJ7Lys1HENn546AgVwcfKQXWCLghiCUFT46nF6HWwiy+idV6Dqzc4Zmos/VHCho6hVIPe0a1yhrgzDSpzS1QE1QfO9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733766792; c=relaxed/simple;
	bh=aVUnsz64ejWmdnGcCpaM1dalStXg33ZxABoCKyq87UE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LYQXIKKk7uKSALpBWkeKD5NPHQkZlIHlg1Ic0Uy7HQiPhPucfY81mOA0CR5T4RWoIu73TEwLwEV5lftp/nPv0qRF3mxQDrnm2lirvUN//cqLJIQWUR0q7M+9nOAxHBaZo50r+5taPiFk3IerLDdp9At/epZxcyyUYb2OWWcrgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbFXusl9; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4674a47b7e4so665131cf.1
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 09:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733766789; x=1734371589; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/K41QGjgWHbPiJSZ5FkrX6YIRP/Q1Ebmrn4ea8wj/g=;
        b=vbFXusl93vLsibN+U0ckf0Yb7hDpWgbgqYJQtE9xEwInJFhJrVIQBz+MLWaCSHWJRc
         S0frX0X11AlyQ2P3R+rOafjlxDx1Bk+bVbllcFXzV0tF5g72eQB7UtUrILDfDZqJUA9U
         sSwig8B2Mw8D/CiOg3kEcAs8uJH22JZjMOcJoM5ftUUGzNFX+J/aro6AH+L9yLc4Pya/
         TMP5s3UJB1AlhW16nJkRN7TqpL6ThYvnJwg3lZsMicqQ6zfRxN2eoUV9t9G58y9JqGRz
         SpTLGZgSpCzwovz0cKyw/jo1flAMoilSzbvTOB6KEwcKwCW+56FmJ5uh3yUcPRzb/VhR
         K4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733766789; x=1734371589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/K41QGjgWHbPiJSZ5FkrX6YIRP/Q1Ebmrn4ea8wj/g=;
        b=pZ7fbxH6y/GVUTPGPIfZqwkzn1PVpXQJKvhUcPl8wt+WQk50Ur2V2nOwtaI07Rcgrq
         FLHwICZutD+UoTd3MFPchw2BO986IXRXapi5NvbkdDYdSpiD4lTgD4Od+XE7jBXtPf7Y
         dImr3AxTuyuLvxRhZ3h0/cfB3pjnfpGTFDQz4DBXRyrsSbdvOL+Vd0jA50kL7QgEhohI
         WpbNHPUsnnyU3GmlUAWqx96QU62l7dbMe5bFClJPwhl6RcXgkU07R7zhmNWVAb6hKF6u
         Z2R+443aU0fe5GSox1cBGlHwlejMel2nuWatMoCN3DYBklgn0hqOWkvz5oI6KZu7V7tc
         luKg==
X-Gm-Message-State: AOJu0YwbP5RhE8HcVc6aIdgIYMoEidssH81xIrmPhqcSrEllc+yjRImn
	9/8dg8bA21t2r26bYvd/a/M6hzBqiUu9pWzeUVRwv1kNZao5Pp9xMvyC9VE0KEv8Myhehti+9CZ
	qbp3ejzPwUKLpvgi8oBOWoiZPgMI+3CMqgfBg
X-Gm-Gg: ASbGncs+r1C35tLi/bRFzpIOJfhA87xjKI6pufOuDsZi7Zr0PRsR7h0OfKcaNShaZGM
	D5+591uLkkGqsPjhzLaX1K9uNf4wf06vt3SBQPrbWYI2IvL6j9ePru6rbo9DH9AAdqw==
X-Google-Smtp-Source: AGHT+IGaidcoZ4uYqPGCi6fGz9pxTP5I9zilcU0jStvziyAiRK/W0dGdLo5BXdwvYDUBcNU7UMtTvaM2nwVzifrYIns=
X-Received: by 2002:a05:622a:4c88:b0:466:8356:8b71 with SMTP id
 d75a77b69052e-4674c96cfd1mr9418031cf.19.1733766789391; Mon, 09 Dec 2024
 09:53:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-17-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-17-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 9 Dec 2024 09:52:56 -0800
Message-ID: <CAHS8izO29gnvrqtj2jA9m1mNQK2UC9yCHd=Gtn+fA1Mv0+Vthw@mail.gmail.com>
Subject: Re: [PATCH net-next v8 16/17] net: add documentation for io_uring zcrx
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 9:23=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> Add documentation for io_uring zero copy Rx that explains requirements
> and the user API.
>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  Documentation/networking/iou-zcrx.rst | 201 ++++++++++++++++++++++++++
>  1 file changed, 201 insertions(+)
>  create mode 100644 Documentation/networking/iou-zcrx.rst
>
> diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networ=
king/iou-zcrx.rst

I think you need a link to Documentation/networking/index.rst to point
to your new docs.

....

> +Testing
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +See ``tools/testing/selftests/net/iou-zcrx.c``

Link is wrong I think. The path in this series is
tools/testing/selftests/drivers/net/hw/iou-zcrx.c.


--=20
Thanks,
Mina

