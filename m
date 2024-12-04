Return-Path: <io-uring+bounces-5211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBA99E4208
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A43216111C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B93233D89;
	Wed,  4 Dec 2024 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Y00N63q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58782049F3
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332325; cv=none; b=Oa50iywWuLR1gf9tvqoPt/iLtNDAOaYFK8s4zxRpv5zn/i+GstmunvoUdojj+n6Z8/LIgh6ayblL3TuyMlSkRE507Z/jh1OT4Ht7giMdh3Z7xRVUO+1gYG7iLOtxyhXSo1R3IV+z+OO7uCKzSXiBCBMJSr97HD8f8pqfz6/jyYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332325; c=relaxed/simple;
	bh=RQW+i9PUSE0Qxy6TrXCzEg5OcyFxu2ieuaZrHjYXOyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKMQ8XkSfMVRx8aj8aAyamIC6l0jP0CThzOVx7sBqgxwjWajqeoTIio6e7120CZgITz/wMOgX89frDQvNhhKs/AGp/g3qKDfvIXIzXVRIbbrZV7XAT1oSEKCUZoT0oA5pJVDQYGPM0N+SfpUKuA8TdCSWtcaZ/H9zjY/k+m2OU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Y00N63q; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-72599fc764bso351369b3a.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733332323; x=1733937123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQW+i9PUSE0Qxy6TrXCzEg5OcyFxu2ieuaZrHjYXOyY=;
        b=2Y00N63qSKYzpg+WED4Lo4lt1VSrJl2lEPHD98OJ0BTu2wxABf/lytOtwgZ/uEcZRZ
         LykuiCMN+OfFvLkjVL5ZDl00h4ODYkMEXd+WQ1cVt1tVpYfqzHay1drMsxkV395mpVfE
         lFsZQKt+ewXebd5MC0AJP7lVUNpBvlpd/YlSG03L/W9a6pRda5aqhW81RJnQGeMIScib
         DrN/dwwzbcgxxFe6+FljAX0lMIoo/P8jmq6B0G75ybRbd+pStHEWxLlhMGfFR1mLT1Bq
         GdbmNmY4JPrZsMAUE+wxXhDsXQSTmLcV4IeCnUqEgJ5MoItIG6uAjRlQ+OJPqkrZmQyr
         htOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332323; x=1733937123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQW+i9PUSE0Qxy6TrXCzEg5OcyFxu2ieuaZrHjYXOyY=;
        b=qXOgWMdUd+Ei35K6NizihMP5Jj7g15eYuDLiYV5w9uwrcinqn2osRgP32E/UYjdloj
         ulG1dm3e4DvxmhcIn/eTUVjRDdvDfZuieGiRLUl7YoSM5+7xpKbecHaGWqdw0Tmo6f/C
         rTYT1uuEPybYHn9zTZN93wDVxmpICTLrU5sCij0tdl4xV01eBxwQa1tsBuA9H7YMeQw1
         DzWZud7h5xBK5B+h5xbiPfk/MnKqAoAXb5IO9kSzUX5QaRdaEU4ivBZF1mKBZ6Qaw7h/
         wmR4Tlhwkkk7/ow9dRti+ryRAEiMsyaXxnqGLNs83YkhBgfUyA3lBEqe42/ctiI5qkJl
         /yFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6KcfenNXTOSTNuChyM6WUMBvaeZKCzzTaRLYcNrtYl+ev3ricBXpLTN4L2WMzaMXeC63t54PigQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw427u6a739oOpGM9bI+/+vup4qL/3x91ktwxYLVOMO6hxYGPdY
	znYW2G/fyD6M+bx8EaJP8p32HAd7dmz+igZ/N+HfbbZF8pzkZzS57ldmUEOZEOJs0ibRsEn7SwH
	gZI6NFpdt5OzOxyLlCwPFFRPBiElo/43xROXx
X-Gm-Gg: ASbGnctYLHfWSfDmkmhs792sgpsE2DeGLuG8GXM9UHzV/ayds1tuMwfkPQC4upuPubE
	onGKKN1QaeHgfWBFOwv9IS7jhESwfa8r77917k9WUsgRVWzEz3Kis3v7PKhv5ug==
X-Google-Smtp-Source: AGHT+IGsbeCJf05tmNmbLH0VE04Aiwfh7Htg0RRLY1iR+e8nHZX1kxB+Hyn1sOnKB+pphXgXlc1sE6uNGzfcfwzpjOo=
X-Received: by 2002:a17:90b:3b52:b0:2ee:9661:eafb with SMTP id
 98e67ed59e1d1-2ef41c191edmr195451a91.12.1733332322845; Wed, 04 Dec 2024
 09:12:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com> <67272d83.050a0220.35b515.0198.GAE@google.com>
 <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk>
In-Reply-To: <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 4 Dec 2024 18:11:51 +0100
Message-ID: <CANp29Y5U3oMc3jYkxmnfd_9YYvWK3TwUhAbhA111k57AYRLd+A@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in io_sqe_buffer_register
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Just in case:

Syzbot reported this commit as the result of the cause (bug origin)
bisection, not as the commit after which the problem was gone. So
(unless it actually is a fixing commit) reporting it back via #syz fix
is not correct.

--=20
Aleksandr

On Wed, Dec 4, 2024 at 6:07=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> #syz fix: io_uring/rsrc: get rid of the empty node and dummy_ubuf
>
> --
> Jens Axboe
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/1ce3a220-7f68-4a68-a76c-b37fdf9bfc70%40kernel.dk.

