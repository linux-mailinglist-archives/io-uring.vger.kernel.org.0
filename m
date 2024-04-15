Return-Path: <io-uring+bounces-1562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A4F8A5A4C
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 21:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5BDF1C21F43
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 19:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19400155A27;
	Mon, 15 Apr 2024 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="gpnU87sC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF41155A24
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713207778; cv=none; b=CNSPlQiZX676aWJ0fao13+aUPLRNK9PAak6VN2yBp6n43lp9q12f+1p5xwprbnp+y6qlyYmMJ2s4kZzpJb7L68EduSj7pDLKIzr8w1vn8XLrujCtlSijkf86W5+DXZ1GMMFJFftpshghkUwo9JKLdjjhlsmjVwVC3uIK+cH2Nfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713207778; c=relaxed/simple;
	bh=+Sl0KDp+f88KlkN5sL9qL6tcIvj36qePcyg1XNCcTOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWn09blbhFEgOWkrZeshHtT9P+86f8qMb8sB2vG24TYUD2o/sD3ym+xhYi49BI4a+KFuqoY1lhWDDOUm8q8dCDNd0i3nYvgfze1Y4NrS0wd8m4PY4IjU+e7sI4gfjorHKr30PrkZeJOTvCqkpNLjGM5gvqawpVM7tD3eDgCLQhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=gpnU87sC; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e0f43074edso2545980a34.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1713207774; x=1713812574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qnuzy4YohZRKFHiloeA4mVaIUDCwUMILHZ7C0FksI2Q=;
        b=gpnU87sCjG2A+yB1sR0hx6yrIJCj3mqA1/XkVLX+KUMZzWfSj3yqLc2mLJAUp5+r98
         QzW7bEDH38MDio36RdPPhAjeB03vh2jCKtmE1aThRdtB1m3dXIFOmTi6T7eAxaER1S/V
         hEArF/ktmVVsN6/O6kanNscl75ylDXidH+BMuhQkDrKp6IW4OmlvEpI+4c5dh9Hmz29B
         jnP9U+DQItj04Grz+HTaMAmnDee1np67V6Vni6ARWGADAvrbN5a6rmMsmPAiEXJebXQy
         Ultkl7CXrG6qSmavylnPPb+gf6OGkqoFMGoMK7e3fOfO+F7u60dYs6PQlCzLmVCV+trO
         UWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713207774; x=1713812574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qnuzy4YohZRKFHiloeA4mVaIUDCwUMILHZ7C0FksI2Q=;
        b=T42QpQa1PAtyVtIW2fmcE//o8CINiHfeQ+xIFRQpBvo2LL0YEpswc+liIV3V2D50W9
         cSuyaIuacRlI63Z/L4lZEws6rveMAELVAAjAJMy+FCKtGdbVVYgIRdeWXQGi1dcAzdC1
         Bt8PmYHgmPwncLEzx7LF7KcQkHGGQgUgFV1u1lDuqon5nzuX2VOrUb3ArqOsze37ysSe
         cpi7jTz8shKuc18HmKSFbtGA8hM0gSF+Gg4ZmMwiQd+jRXLJouBHvDxwmgZrZp1KdY7X
         InavCWEEF60crA5xCD8TIL4+GaDtbeZKJ6pnYDvxvT1RSG2HnShGaEfqRsUmDN7QESIp
         R5IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgfBzQ3Qtaz1HKtGxeko7YYkBMLua2+MZSbe07LEMNMT/WcS44QVd5c3lFcbxDeL2rko3K6zDKrizwONbCY/mdVxppPoyNLBo=
X-Gm-Message-State: AOJu0YxRNAR13vPsorOYIIYPRn6WOZ2YjO7rDmjtgBoRQtBkwYySJxGR
	BI4gzu1HujmzWChpjRWaiaZZKBO0ibo8sTRJrvdE7YuE5C02GudXCOfYlair637P9bwHuWQ5257
	e6pP8r7aDCFjPMNtc2hkUudeU+qFo1R9GsT5w
X-Google-Smtp-Source: AGHT+IEZFN4hbYjCj1ww/D1sjvqe8pOqx7vvJkr0xZqROOpJDxITAIMHtAwtRNrZa/YLYN0XY/RRnGvMJysW4KwpFmQ=
X-Received: by 2002:a05:6830:1484:b0:6ea:386a:44d8 with SMTP id
 s4-20020a056830148400b006ea386a44d8mr11138794otq.3.1713207774198; Mon, 15 Apr
 2024 12:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
 <CGME20240328155911eucas1p23472e0c6505ca73df5c76fe019fdd483@eucas1p2.samsung.com>
 <20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com>
 <20240415134406.5l6ygkl55yvioxgs@joelS2.panther.com> <CAHC9VhTE+85xLytWD8LYrmdV8xcXdi-Tygy5fVvokaLCfk9bUQ@mail.gmail.com>
In-Reply-To: <CAHC9VhTE+85xLytWD8LYrmdV8xcXdi-Tygy5fVvokaLCfk9bUQ@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Apr 2024 15:02:43 -0400
Message-ID: <CAHC9VhT1ykCKnijSbsgPXO9o-5_LHAtSm=q=cdQ8N9QH+WA+tw@mail.gmail.com>
Subject: Re: [PATCH 2/7] security: Remove the now superfluous sentinel element
 from ctl_table array
To: Joel Granados <j.granados@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 10:17=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
> On Mon, Apr 15, 2024 at 9:44=E2=80=AFAM Joel Granados <j.granados@samsung=
.com> wrote:
> >
> > Hey
> >
> > This is the only patch that I have not seen added to the next tree.
> > I'll put this in the sysctl-next
> > https://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl.git/log/?=
h=3Dsysctl-next
> > for testing. Please let me know if It is lined up to be upstream throug=
h
> > another path.
>
> I was hoping to see some ACKs from the associated LSM maintainers, but
> it's minor enough I'll go ahead and pull it into the lsm/dev tree this
> week.  I'll send a note later when I do the merge.

... and now it's merged, it should be in the next cut of the
linux-next tree.  Thanks!

--=20
paul-moore.com

