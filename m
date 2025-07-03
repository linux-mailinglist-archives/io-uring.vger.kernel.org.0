Return-Path: <io-uring+bounces-8598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE79AF671B
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 03:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E78F8522180
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178D142065;
	Thu,  3 Jul 2025 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PRPFaZk7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85374282F5
	for <io-uring@vger.kernel.org>; Thu,  3 Jul 2025 01:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751505813; cv=none; b=mrBn6smx0MkLKcDSTV782fBM+KGcIR0PgX6rnsT2+eHGjBnIhvAhXsLsAQi3GfTcAP4UkFc1jcR2tRfR04UtpOA80qAZqd4eW+PxfwkjVFmnmyWtb1U4X7nQbJctNh5dDaP/mT9RhHPNqp7f1wjcnC4nVxmQz/6kiWWxexZ7AQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751505813; c=relaxed/simple;
	bh=XcWyjul+cST6dc8a3yJU1N8vgrQ8Cjb4ZU3ZLa7vC6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wl7/XgNgaD+SlEcWc/03WRgTo7ZkMlA7NcMdmLFZ+QDaOKN+aei5A8170Xynwgo2dbjn7PQPN3HdAI3wFWq7DQvQIcM3UUynEfB/LAxPZcSUIgdmFMJ9p6iP6u7OIDS/lFgySGNiJlYcvuGbGOPBmzf7y7lSDTV+OgaiehP9m/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PRPFaZk7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23c71b21f72so1418325ad.2
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 18:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1751505811; x=1752110611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XcWyjul+cST6dc8a3yJU1N8vgrQ8Cjb4ZU3ZLa7vC6c=;
        b=PRPFaZk7I9umpsofnN49HppE+eGmT0cqaE1vG+zxf1YjYnUOzn6cNY0W7enIXhxRTR
         2vGx2oANlYN0XSw6GYo8ueEjovWjd2Jaan6+wcKJqcPjN10CHPVvQuKf+9sp0nalRgRT
         tc3PBzSOvoOuehsOrkdeJg6gxUk7VeFfqNT+3TpvUxx+A9FBX2aIn+VCew3bofHF2DBx
         kwThT4xytettkc0O4j5A2yzsiHnL61L60K0faw491JzU931TZlo4P7TsxQAoIuxrV1f4
         YzxQljDo8Qe56TDJ59pYbsL+VSRkEXxD+6ZmI9GYCpKWt45Qg4orr1wFaqUn15sCSVgn
         2w4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751505811; x=1752110611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcWyjul+cST6dc8a3yJU1N8vgrQ8Cjb4ZU3ZLa7vC6c=;
        b=YdD3BYzVZ/V7sBSRSTAmfCAllE8AiDFbmYOTTs7C2eHl1urOsV0UU74W0ELjGKjh+0
         Nx6eL7IxPDcmttt/rj4VULUnlnOw/RzuH14OWfh+9zcBE2rF7S5A13TaUaVGRdcJZCDZ
         tauANYwTw7BzbeXrGfsSlz5UWOp12YxyvODY/bDX2rvP2l98OpkT+d1qgrUF2H/DNMJH
         L0KXyHNH6Gx0cvJtW1aCAiessk3QXtghD8Z0H2ZwTq7GYAFrjawmYh7TsSrrNf0hwYNC
         7Iyd79T7/8AjeGv8XfdpgjjZ19AmfIiGnW1EPz6+BqWCTnkG5JO2KdRUYj7oGEkIh7IL
         ezxw==
X-Gm-Message-State: AOJu0Yzmi7+HRnlnB8jU8zhTciTDV4naZgCZpEtJKXJoEpaNLsJHPAa8
	Vma6ZbosYXxhbwDEwPFKozFKsp+qofRnyJeBOgsCSEVq61JHEkl4huxwloijogeK/xlH+JO+yua
	CSl3M+BT1LYjiUQGzR4420BzNguHaSU+59iJWDADcwO7kQUvBU0w6CPA=
X-Gm-Gg: ASbGncsKJOmGuj/pbOfx+KEfJ/MIXIk2wa6OUQduyYkxd1amxAoDHpApLv5guqcwzfe
	vYJtgFz8u2dWLh0yefkO7PUEFwtFKtohnOyKU2LBuPR8mW/rj/cH/Gg6SQ6iSwQ5cSTl++vBYsK
	rIPSVVUfh4+jQjRRp8vP+kXtsdnKvRsIgMmQKAiMBDUpWOZ5xDbHGj
X-Google-Smtp-Source: AGHT+IFkAQkHEbXHbguNdnR6/BTUXsGm8pJl1CgLp8QiOM1hktxb1eIWny0ADa+KsSrsRdEyWtTgNvTjIiAt6mgCsKk=
X-Received: by 2002:a17:902:ce8d:b0:235:239d:2e3d with SMTP id
 d9443c01a7336-23c7b3d9335mr2342685ad.9.1751505810682; Wed, 02 Jul 2025
 18:23:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619143435.3474028-1-csander@purestorage.com>
 <CADUfDZo5O1zONAdyLnp+Nm2ackD5K5hMtQsO_q4fqfxF2wTcPA@mail.gmail.com> <2cf2350f-286a-42cb-aa02-2eee7099fe22@kernel.dk>
In-Reply-To: <2cf2350f-286a-42cb-aa02-2eee7099fe22@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 2 Jul 2025 21:23:19 -0400
X-Gm-Features: Ac12FXxXJmAT6Oz1-QPefjbPTLW4CR97tTMHUWIcn3tRGFvBQPlIlzWWfYbWBVc
Message-ID: <CADUfDZqC9n4jcT_BhoraFzxA77wSyJ4+KZ7jvOs=a_cvr456WA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: skip atomic refcount for uncloned buffers
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 7:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/2/25 3:11 PM, Caleb Sander Mateos wrote:
> > Hi Jens,
> > Any concerns with this one? I thought it was a fairly straightforward
> > optimization in the ublk zero-copy I/O path.
>
> Nope looks fine, I just have a largish backlog from being gone for 10
> days. I'll queue it up for 6.17.

No worries, I was away for a week too. Just wanted to make sure it
hadn't fallen off the radar.

Thanks,
Caleb

