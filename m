Return-Path: <io-uring+bounces-8562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AED2AF0BA1
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 08:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D35A7A3660
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 06:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47FF21C19D;
	Wed,  2 Jul 2025 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R0aYEvhX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F6A219FC
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 06:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751437661; cv=none; b=GoOl8zohb1cLH9ajbkTYVw4WUO6j3UHgkApS+qxnufLtXvrYkQp26IQQqv5yB3WictrQxA+pYlfXkrahXWQd7Z4JmIDQ9sBXo67Rl8ZZ8wTeTxMFngC6IQPHAJwXuuXLCWXLnhcrvvOL/LMaQPqkTfTffi615EaMSnFi7rnjIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751437661; c=relaxed/simple;
	bh=myHASR+X5ssBqjEu1CM8REWLywC8Qy4nEDxDpgmgB2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=misM6L2iLyb1LOF+qO5N0N6xWz3XWvYliI7WTydxJ3vPok+t1+cx6HHMoiIsBz97+0DkxysxJten4+GMEcogapiStr8qLDh6WTJ7aEdTd79IXHh/GERBgHXVHrEmou+Wbz1f2oAIOhtN0qvnl0t7bkahWTiT1ChXZAgZh8rxll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R0aYEvhX; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0ccfd5ca5so568334566b.3
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 23:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751437657; x=1752042457; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WfvX0f6CCpo4khEDE50idlQCLa2H2opfHCksFcfRdXw=;
        b=R0aYEvhXibM32BYEl/oPXWdkVlFXTNOYzeobEL/55tlwIl1ojOZ2+Dvn0569/sZlkn
         Ya9LEwQKSqvFa58F+8CcM9qDWZ8uGu7a9ZRpUlF0/ypmPdx5baym8EoM4oO7rIUKL1Kx
         vSI9AAJsVYEZw6y4EWTuxBtKuRdQDmPJy4kYyw2IxHv8KU3xdZciL2SVwYzcPDpd4S8G
         xcJAd3zGMkTPrx70NHBnfycqpgJNhzhu79jgjlmF/wBPtt7qha5iEteEuuFjuY4eVtra
         4qHrM5xNEn90fODoHjV4C6KqWhGP2rAGY6Drr4+r5FM/rp6lsqhGUdr2AZF3YPl1tGin
         M3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751437657; x=1752042457;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WfvX0f6CCpo4khEDE50idlQCLa2H2opfHCksFcfRdXw=;
        b=wZ9eGLDPT2/apPqkaTwB+kl1uJm1J8VMnjWCSA1Yb1pijKs6cRyBr1rlZpbITneOig
         9VvzGMp4OcJRBadOhd4pk8uIJ1+IjkKC4X/TLCJKy2CPRf35R7KtPuREHIlmb+a+Mwja
         wgRehE54wbkOtXPLwf7J0hysG1ccc1W7qLQSz6URRmVs7LMQf1bOzR/9hk9e6O8ym1lb
         NYt/K9g+xTGPC1WZixUEWUNew6f6CjerIuSz4BgQLZff+Jvy67nEDOhwuY9DSFOes4zX
         LbH21+YTS6we0Tg/zHcuAh507j01+HtyEryloW4NkhxgWSn+0qqzZzuNtHgd3EkXTPPw
         w+VA==
X-Forwarded-Encrypted: i=1; AJvYcCUvmayFtWrx0ARPG6AK3ZpbhW1Kj2aaCiBeotU59DiLifVJd4lMrJDhKntaZ7mUPXM2Ueec1RJdqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxXFw55p/ekXXdOgOo0q6RE+H+E66zAWtYs1gBWLdvW8vj1n7
	xTL8mFlZPISxd9wz7kn+gcm4x72AJX+j6xTIZglGKxuejg3FWfwCb31aIbcAKuti+Eu+2MWlRNe
	4e9pw/LcJ2t7dDytanOEFhcRXySk6hms85GxTDLzWXQ==
X-Gm-Gg: ASbGnctV6O4gXXOyXDqFaY5rPUxrVfl+6HcciGe+UorANwbk4nfQRk9uEMxL0zOEhFZ
	MKZYxudP6udRSuEMG2SYM1vsAxMLiz7JHMb7qQn9BQI7AcBspcvwXMvC7OInNUdXut2VT02CbvQ
	fmkzDW69y6+1L12M0FdLM0rq2rDa3FjrQTku9w6jGu7A==
X-Google-Smtp-Source: AGHT+IEVsP/oX4SavVAomHyls7aE2eXpU769FttlHpj9iGiqfFPRyb3bd/0w0SwVCgrXq2hCbU8tVxR2F6muLA4g2gs=
X-Received: by 2002:a17:907:3d44:b0:ad9:85d3:e141 with SMTP id
 a640c23a62f3a-ae3c2e1a407mr159852866b.53.1751437657457; Tue, 01 Jul 2025
 23:27:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-3-csander@purestorage.com> <76d3c110-821a-471a-ae95-3a4ab1bf3324@kernel.dk>
In-Reply-To: <76d3c110-821a-471a-ae95-3a4ab1bf3324@kernel.dk>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 2 Jul 2025 08:27:26 +0200
X-Gm-Features: Ac12FXw_9in0adUkmoIgljnvz7S4Xj-lA7oSoD13D_kmAXoq3dHMYxm4RdfBGD4
Message-ID: <CAPjX3FfzsHWK=tRwDr4ZSOONq=RftF8THh5SWdT80N6EwesBVA@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Jul 2025 at 21:04, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/19/25 1:27 PM, Caleb Sander Mateos wrote:
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 929cad6ee326..7cddc4c1c554 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -257,10 +257,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> >                       req->iopoll_start = ktime_get_ns();
> >               }
> >       }
> >
> >       ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> > +     if (ret == -EAGAIN)
> > +             ioucmd->flags |= IORING_URING_CMD_REISSUE;
> >       if (ret == -EAGAIN || ret == -EIOCBQUEUED)
> >               return ret;
>
> Probably fold that under the next statement?
>
>         if (ret == -EAGAIN || ret == -EIOCBQUEUED) {
>                 if (ret == -EAGAIN) {
>                         ioucmd->flags |= IORING_URING_CMD_REISSUE;
>                 return ret;
>         }
>
> ?

I'd argue the original looks simpler, cleaner.

> --
> Jens Axboe
>

