Return-Path: <io-uring+bounces-9077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A22B2CCFE
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 21:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4816A4E0722
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 19:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A447A285CBB;
	Tue, 19 Aug 2025 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSJaK/XL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CB42AE66
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 19:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631986; cv=none; b=R6cTVmArFGVpb7ACw4by7PyE0e2QLuYkeEmJrc+kwA1Zp0za1EPb+96l8KcCkRU/Rc6W3tPrrE41pKwn4bTB/H+TG9M4D8KxYCTyKMgcSKWBFiw2nMPkWbDPiK1dIm0Y4WYopoTml2OnLBFVl1p7f/FjNndCbLOqZxVq8MA7WPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631986; c=relaxed/simple;
	bh=Dlc+gv/phCrMNJTD7pA0SvuOLHUdk1RTYlblxps6Ixw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3zeKS3tsoJclw8bKDEEkpupfSp3nLkIy2J37crioIM9B4JmhNYTOHI17GERVHa+2Zb5a6gstCV8TNU36CIJc6SwITNciwdqIlsvIBDgDRNeudJ52RG6j9XwI00KxefAhZO4wmI+YztNTOxOrIgi0wUGlJOJ5l+cHsYhNpHJZZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSJaK/XL; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b0bf04716aso90211cf.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 12:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755631984; x=1756236784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dlc+gv/phCrMNJTD7pA0SvuOLHUdk1RTYlblxps6Ixw=;
        b=dSJaK/XLjjdkIlg8JnQYSU9gcXJdZATsA4dCEIJI3vfWY3BEVYPbTkQ90ZISFuEcGd
         TFgmrIYvuRRxusOa/Lh8s71TXhh65PXjFplPRipgty51jJW9zpN+Be+ze1RyixXxmOwl
         XKYbNfdySb1fP9vkrpKXdQpzZTUdULgGoR2ujho/yeKflkiOFcse7K6md9jryOc3iWCr
         ZeYFETYhXbq02CtDiwDFLRdbsXsztQsnp1WhNZplvp5tis3szI7yTBrRhp1IzsOfYfBA
         EzrD1xP/zvZ5KQWlxqyi6uHr6K2jNd0/dkgEBmQRl8K0DxZu3s8G2BSSpCv3DWTbth+g
         b3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755631984; x=1756236784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dlc+gv/phCrMNJTD7pA0SvuOLHUdk1RTYlblxps6Ixw=;
        b=tIc9/mXdVfBikimi9Pu77UdobFwv+29CA72Nvz/ILihMzyvhgCOZ4fvmWh1jNaVZo2
         Y6X2OGXbkq1hpTEzloN/J8OcJIsguTej8Zig1xJT2y9FhuJ++1hm/sone5D8AnLZNMxF
         QisKkwYReK7yYDPw+oGEn288FcixiB8owkZYhZmT2IKg8+p7Or8kJuucnNBpPbIsxPA3
         oxqp5IMu8mM6IKHi8KBgyajXhEgfxWy9kQDDNGyLcl3BOQXE0MD90HU4wEYPv4KlCzm2
         k6oUeZ/abwjG6D1NYsQjbFroc54a/3mOeCLjiaEH/wxQ/k08qDw3kHhYBltRc3E5cOoB
         Pc7g==
X-Forwarded-Encrypted: i=1; AJvYcCXPDaqOZJ2VISYiCIXcYGOpVpqtp6j0KamP07YO+1W39lKBVSLETRt94e/ECMFIH8PR1WT/sk+t3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwP79Isvh0KutilPYf8Vnu6+ZyVfyLvWG4rRpP5odOeRAtaEU0Q
	/P4teO0du1iwArIRBTLTIGScKe2f9IKdX+SLiezYfXsjNdX4+KC+JnT10msfOUez8Bu2Ab0/if5
	2mxNSy14PLBJeBR99u+znVswnMCUYM8vm84lBZaV9
X-Gm-Gg: ASbGncsPrncXEiDg/SL3MoqP4x7EfGQAdnTEyBBy+Jzp4UCkD2q3L5tr3kuTPUaYaVy
	wxKj+UI7vqxEAXsp1LkBWmGlx9/sx7F649EVR3YzU5vUutZ03j9LIaUAgamEFWh5zWyYsV/d6Jk
	adxulyaiWLy6Fq8SJeQvqkz5YBf447tF1nB2ebroKCkjPYWZJ/IF/yHoT+lEJIdr5Om2XNykQBA
	rM5P9qPpyJO52ue/L3tSCnODExjvw6xnFrEwqKH5qKhBIh0bJkvZRM=
X-Google-Smtp-Source: AGHT+IFZOUs4HvSAXDicI6HRK+xenYcqiZRbzTDhlDFCbIHyzB/2YxgCL8t0otnlqVer1xfFluhajR27sxVEpthm9Bo=
X-Received: by 2002:ac8:5949:0:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4b29190f742mr958271cf.16.1755631983445; Tue, 19 Aug 2025
 12:33:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <fab9f52289a416f823d2eac6544e01cb7040eee9.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <fab9f52289a416f823d2eac6544e01cb7040eee9.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 12:32:46 -0700
X-Gm-Features: Ac12FXyzzAHQkZQwTmfShgjuBIC83fo8ZLZc42_ORo6YGwvB1xgCyklsv26SR98
Message-ID: <CAHS8izMPCOp8QeC9zZddBYaGSNd-9+CtV7XbKOn43pHb03vi0w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 06/23] net: add rx_buf_len to netdev config
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Add rx_buf_len to configuration maintained by the core.
> Use "three-state" semantics where 0 means "driver default".
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

