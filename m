Return-Path: <io-uring+bounces-6650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0863FA413CF
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 03:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41EBC188F650
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 02:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EEC1714D7;
	Mon, 24 Feb 2025 02:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrOl8WbB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C8019E994
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 02:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740365823; cv=none; b=N8KrhUSO31b3EPlfCs5MbU8iAUx05Xwv9dCpALGj1y0EN9XEBcAQ8SCDc9pfy+ZW5fXgi4SidjapK63iccJNKKYUDPmw7A6xVQ38Z3rD7C/G9eudAAhbq6srQuYTk0d2Q/cnBwReEobYgfemiQSOZ0anOyAwUPHffbO6yHoNp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740365823; c=relaxed/simple;
	bh=goPjuJpDX0pGM88GU6lGJ+JbrCPDhvRj8ukDEpXrFtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kXL6VPHeLBLIafT6DuaWokcnYUzGtR2sBrZtzWEN3XSKB2St8+uAwULYr+v+ve/XNUdWKDo5H1gguuQQdoPie5ESYK6YuViSraHZmwmsebzhSiT+ZUPE4hT8VwF8kld/ICjWBpzM1C5meen5AGJ7ylvewp9Gc3GJ5w5CFVcTnWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MrOl8WbB; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e04f87584dso5636230a12.3
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 18:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740365820; x=1740970620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yBaaVcQFRcmoElPAaWFVjhW9FgWd6oFwSpQqgblJmFU=;
        b=MrOl8WbBXGhpjE6O8MGx3Y1VrD5v+6RzAASy5+Fw9y0GfiK19k9rOICirs02F2Xkjh
         KE62SacyDQe2CXv3BXY+CeJpCj0sCIo2K8YTAiRQ4rnKBTpIDCEq7Koac8LQV8ZCN7fa
         mBdTWqzwXZGc4kXLCynVKkqsLQA4yNkijyFjSKNV7OGGO84UU6DYjL3P7r+ZudXk6wS5
         a0w1QNZH4sHGubxVz+UKU6NIKdkNBd3CqGB/QLm+BuIFFNlSuWng+SQViX/dg8+p0+gh
         Jzuwhkal1t675rw9pPPOXclLtta7a6pyTzkS0X9C1pIB1YOOZe+a61HpUcdUiHkvb4No
         Aj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740365820; x=1740970620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yBaaVcQFRcmoElPAaWFVjhW9FgWd6oFwSpQqgblJmFU=;
        b=Sxt8zprRqlYc30KDu+gwyXg3tXRSYwpx6LN55iUmkXBYIhEHhbgeXz0F17Bne+0113
         5Dxa24V1R0+fG0yHHdep7xYu2aZH+zDA3MjQRu43NWodVTCzpgpfjNTw0aCXPWNV870J
         zBRvfxU6PmAQMGYq8URXgrMdYeB3D506oh9MkvLB/Wtwlqq76XkGXXZxgvAiVLrH5VV2
         cJYxmB6SI92NAEaI7ZHaaUJhD4fxjveDfnRdea7iCPGDM3dAMWbhReUfouGubfN81JHI
         i9awRz/EDXqxd8dcU/mwuO7US2+v/NHPudC3CO5sUtatdshLdjaHb5/Wt9or/tZx0Usg
         tiWQ==
X-Gm-Message-State: AOJu0YypI06TbziZgtC7/dDL8iIqKWQiONX+g+gPAcqfybuD8tmKv+Va
	mjpP8lMzvpauyLREcg8rHTryYS1t5PQ1lINLT+7hjieb+pz3HU4VMRB7Pnj2wMID8w3ePqgO3DS
	WdeEfN4YNCoJ1UVinr11a51VfJ70kh0Y=
X-Gm-Gg: ASbGncsBZdZwwlGZW8G8WkuqueADgZK2pHllkgAzw87feXGr2R6GF5dz7uwtalGQ5WV
	uQ0EnsOPwPvk5ne5c3BnRkUW3nbsAhWn083TgkimZTOiBVb7OI5L3phdduFZohv2dCrX8NKHmh/
	UO6rK4+/fZ2EoOfwTnWqwAqfNpheskhcHlFUE=
X-Google-Smtp-Source: AGHT+IHfNKFhCBza/0irqtJHGtcW/7fkx3yA8KTTMnegasRlU2exHK020l2VNMZIrTxTwyHnNKSZyzVfujRIr4Nwcw4=
X-Received: by 2002:a17:907:2d22:b0:ab7:9b86:598d with SMTP id
 a640c23a62f3a-abc09a4b7c6mr1050334266b.17.1740365819761; Sun, 23 Feb 2025
 18:56:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f03a112031e9d25f10bca0a3d0b7e4406fc3618e.1740332075.git.asml.silence@gmail.com>
In-Reply-To: <f03a112031e9d25f10bca0a3d0b7e4406fc3618e.1740332075.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 08:26:20 +0530
X-Gm-Features: AWEUYZlAOvfKiWH4wPY7UAo_aTJ7QgmZnakssTM6zMR794-f8nO4TzPlHQ4_zvA
Message-ID: <CACzX3As3UyR3AuQBt=48DSjbzvAQoG18u_O_j0PCNpZWHL-=pQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: compile out compat param passing
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>  #ifdef CONFIG_COMPAT
> -       if (req->ctx->compat)
> +       if (io_is_compat(req->ctx))
>                 return io_iov_compat_buffer_select_prep(rw);
>  #endif

Should the #ifdef CONFIG_COMPAT be removed here since io_is_compat() already
accounts for it?

> @@ -120,7 +120,7 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
>                 nr_segs = 1;
>         }
>         ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
> -                               req->ctx->compat);
> +                               io_is_compat(req->ctx));

Should we also update other places that use ctx->compat (e.g., rsrc.c, net.c,
uring_cmd.c) to use the new io_is_compat() helper for consistency?

