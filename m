Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9024899B4
	for <lists+io-uring@lfdr.de>; Mon, 10 Jan 2022 14:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbiAJNU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Jan 2022 08:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiAJNUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Jan 2022 08:20:55 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B79C06173F
        for <io-uring@vger.kernel.org>; Mon, 10 Jan 2022 05:20:55 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id g14so9378298ybs.8
        for <io-uring@vger.kernel.org>; Mon, 10 Jan 2022 05:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XNye1TnFFysA92DS32jbU6JjhG8n0xBu2ZbXY8SQOOI=;
        b=MH2XQU9Wcf9eyWxg0gONvc7HCz8VN/QoiBIb4bbwdYePOdSIpYZaN/xQ5zzLfNnNPG
         DqIr2okoDO2bwR80dexXQLZfiI/xaitFdiA4lRyiHPzpBQjPs6QMOzA/TXyBE1NgsTk5
         PKSyFUvxQQqc+OeurtJjyhdEa5pOYqJ24Kx5rHRfavloAz1c3E2X4rOnZ1tdKWDE8eR0
         T7MXvMizyAo/voOVDRNrwiWwalDcfLdqCQhGEtzE1fj1T8AIquCjcjVcbyCul+mqIoQi
         KywhKjUPbQu9g8SFKlMWHWe1UQ44VfPw6kkb+quoTE7XafynJMACmbQAthTDC57uMGKU
         pLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XNye1TnFFysA92DS32jbU6JjhG8n0xBu2ZbXY8SQOOI=;
        b=uVQh0h59AjKUDjIht2YfQrKmpReyrzvpkm5Bz2Q+Z+9eknAELwVxxBNPI2ohV0KJaS
         7CiPmVjgvSkmo7sP4xGggTEAHIs5DY9xz2NrJuiW77Ki4UwiZTFZAy9btLg8zZVKc94F
         B9ucOkVQ0VxRO5QUUyG6rp15o4WeV9D6DkQ1vxMRJ9Sqi88X+SsYKkuOs1MTf+RxYI8i
         BCv2tLIRoVKnFWFFze3Y1UOuJl9o5mgsPcXOpp24kj1HLN3FlCtnCABg3/HMEbLQgOK2
         pXPqZGIbBeR7WXCf0KJczsh/YAk7RLPv64NCuqjJ0H7TVe1+y5IVYovCBeRHGVCsUOu/
         0Nag==
X-Gm-Message-State: AOAM533sHA6t3o/9spJYoC/j7xQ6rpPjKdN7ckbA19a158ucBNU9ZKOA
        AaGZOG0860tgDXRRgZtLeQ7goSI8dcDgOe1DOT4=
X-Google-Smtp-Source: ABdhPJzXahI7cOaa52c/s7h/X38R6hJp/LyRYWqMYB3LDfl/t0Aqa709daWdIxLqJRk18wje3aN+eiWv5OK6BXcsj9E=
X-Received: by 2002:a25:fc4:: with SMTP id 187mr1607718ybp.608.1641820854165;
 Mon, 10 Jan 2022 05:20:54 -0800 (PST)
MIME-Version: 1.0
References: <69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com>
 <164174539343.69043.6549592398281965008.b4-ty@kernel.dk>
In-Reply-To: <164174539343.69043.6549592398281965008.b4-ty@kernel.dk>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 10 Jan 2022 14:20:43 +0100
Message-ID: <CAKXUXMxnowRRZTLZAW_zF0Su8PYBKJc3x3j=m+-cyM6ox6E2LQ@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: fix not released cached task refs
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jan 9, 2022 at 5:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On Sun, 9 Jan 2022 00:53:22 +0000, Pavel Begunkov wrote:
> > tctx_task_work() may get run after io_uring cancellation and so there
> > will be no one to put cached in tctx task refs that may have been added
> > back by tw handlers using inline completion infra, Call
> > io_uring_drop_tctx_refs() at the end of the main tw handler to release
> > them.
> >
> >
> > [...]
>
> Applied, thanks!
>
> [1/1] io_uring: fix not released cached task refs
>       commit: 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9
>

The memory leak, reported in
https://lore.kernel.org/all/CAKXUXMzHUi3q4K-OpiBKyMAsQ2K=FOsVzULC76v05nCUKNCA+Q@mail.gmail.com/:

    - does     trigger on next-20220107.

    - does NOT trigger on next-20220107 + cherry-pick
3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9.

    - does NOT trigger on next-20220110, which already includes commit
3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9.


So, with that I think this patch resolves the reported memory leak for good:

Tested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Pavel, thanks for the quick fix.

I guess that the patch has already landed in linux-next, so the tag
above will not be applied to the commit, but is only for our own
historic reference.

Lukas
