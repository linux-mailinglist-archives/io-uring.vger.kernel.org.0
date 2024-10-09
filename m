Return-Path: <io-uring+bounces-3527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C92997652
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D6A2853AA
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A685A1E1C37;
	Wed,  9 Oct 2024 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXMb2NAX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290AB1E1A12
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 20:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505169; cv=none; b=KeublTVgXOsCan0QYfmUP2u2RDvwDfeN7xOZSx/t2yxABJlNVia7//YFhlRFGyPwOtFg78H81yCKmfslF7h6ykZGGtj15gHxwLcgTQr4a+yApV8T/JRP1H34XP4Kwzq5HeHc1UOqWD5rFZ0W1RLMF6MarPYpiyBfeJHxqHgsAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505169; c=relaxed/simple;
	bh=wbKfmr/ZzZ0zcPbDJCjLCYSu8fvlkLgHwSmKN6bz87A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NFq+rcK2ScYtZ8RgQHvJxdnkOWqNJg3Os2JFypuPaL2hZGbTXwzlv4oN5PYk9VKGdmZwdykF5b4io2VcvCyE7TzDmpkmlljEjTtXo0fQBB6G01M0aXZVM/EpNjieqeXK2/KDx3wRoboWj8gGQEgjZGQAhEWr7ZNgF8i+IbEuDX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXMb2NAX; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4601a471aecso15871cf.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 13:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728505165; x=1729109965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbKfmr/ZzZ0zcPbDJCjLCYSu8fvlkLgHwSmKN6bz87A=;
        b=NXMb2NAXxu3qh5WNBIJ3WcVr708oBR2NohNtTHAIxtgiN9iWKv11gh+yBDeweb6FC5
         cmfIJHJzzsyCWLeQi6jxfuXmsQjzc00DLCUol6KbO03AknDhCg0kj2JbgrsS3f61da05
         06YodkHQ7YVxzY06rkbk7wsgt9YD3MlWQA8s1+RW2Qzi+J8jKNQWUIEGfiFEt2Qgc79i
         aazUT8+z04NmC+/DapAVP9THlFw/KzTmj23K+savhbl4phTZ07VmJG27qRiPRfcvGUc5
         ShopkVrIINmaIW/SWyk2j3QhjFsTmebcswpSyWp/WbEWMwfhlWyAZxeJyt56oTgaMBgC
         233A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728505165; x=1729109965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbKfmr/ZzZ0zcPbDJCjLCYSu8fvlkLgHwSmKN6bz87A=;
        b=a5EEX3INN1Ylztxoz8rsv3scp8FfBv0CVf+UBpeAQN8tylCscIepY2jfaCfzM5JrnX
         qPo5JJ8wfnIguhQM5nwZnqcdUppndzNHKCKNic+f/V4XJEpUrVFhlEIXdd36KSPR+u13
         eDUp6li+0QUxJAJL6YgUh1FvH7rB7sy3MyApxdrDPyLrlpz9foXdz2B3yqevEFC67PM5
         EWJzs5Z+luXCX/YfbzCCdQSbg8N4I1rvcyGIh2J5Te49VDs2luUnex02leoklLrgon9T
         MLAZuBmg06m0UCe7yGpoM2n7BL/FxF2pBgxQgmU3t7BZUbblEtZiKHmJ8BMQL7ZOBLjb
         i49Q==
X-Gm-Message-State: AOJu0Yx/rr0bQEx+4VALvKd8EKRNS13mw7p1cAZOeUyjbhpMnIp/BhP/
	Q68togdxGQp70nePbE8VOFIct/gO1Cz3RE8eoMgRb+fh024DYgC+WbpRrzfW4a3+FBEDu7ZauR8
	PQa8TgrWgaDEuTqn8P6p5oFkhJCXSoiicWEfI
X-Google-Smtp-Source: AGHT+IF4+iYkIm7we6CcSbNvjBz3PbvQiC2C9feaZjjA3RZNL/HktZRO9B3jO/+II9dpRAqKJdwz4QJZg7JLrDqqu2c=
X-Received: by 2002:ac8:6507:0:b0:45e:fe4a:1f95 with SMTP id
 d75a77b69052e-4604035c3dcmr876651cf.14.1728505164758; Wed, 09 Oct 2024
 13:19:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-3-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-3-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 13:19:11 -0700
Message-ID: <CAHS8izPDC-puGLNWmP=iQ+skLPTuP9Ydu_T_h58Vd5x9kmhrww@mail.gmail.com>
Subject: Re: [PATCH v1 02/15] net: prefix devmem specific helpers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add prefixes to all helpers that are specific to devmem TCP, i.e.
> net_iov_binding[_id].
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---

The rename looks fine to me, but actually, like Stan, I imagine you
reuse the net_devmem_dmabuf_binding (renamed to something more
generic) and only replace the dma-buf specific pieces in it. Lets
discuss that in the patch that actually does that change.

--=20
Thanks,
Mina

