Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA628D4F0
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbgJMTtE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732282AbgJMTtE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 15:49:04 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2BEC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:49:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u3so4516pjr.3
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 12:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=azTn4fYcsb9QgmJPQAawTDMXTsFjwMYD7ZRewOEzXFg=;
        b=Kg8ID8/atBL055e7IqeqHlAqWENd7rNwLnXooxfy359cXJDa8cbp0TpbYDmad/tgp/
         PpyR548BF95scSSOUHfrtd7AkbrYUM5/k55hu6OU7fNJuhu37A8AZs5xXO3jX+v6oWzo
         DZwyacrlj6RnKy0nnURgicNZqLXEMa1h+LDTe/EipksZmPR2tvhwqrZ+iuRNhFMIurLf
         4O/ScMT/gMl7PA5GZIXV6VAsl6bqxaz+BGzVDyfgNojF7XMu7Qt0d309H9lgElZY+jRx
         b3inkZuY+9ARcKcTeTcogzR++R/eUpWt5vKGr5LCUDo2gN3AvLvK39/OVtE8TRBgb14H
         HqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=azTn4fYcsb9QgmJPQAawTDMXTsFjwMYD7ZRewOEzXFg=;
        b=VeQ2/Jr57n6/9w3gkDli5/O5lMHFkWCCCt7spXK3oBIlrhf0sZgMpwWz5nqdzKWJuA
         zNWYHvsEuG5sURsMUP28bvLqYteS5CQdUtBhMarKlFrsD5yXENF0Zy2P0S8OxSG3VO6Y
         PIJXAK+zBKgtc7rixavtZsl5PjQrfVSd8FRiPVgnq1Xcstq85Cz2oUgPbwoRdgcnaffB
         z6MsckhcFIaO600nNYf1jGRUlFeWHFnj4PvtJmn1XvF6ally/Zf95gyPTonxkiFPq1BR
         bV2a49QfjlwAtp59DsVXWRIV4mDZ9LKs6KyDkRXevblWmGgty/AGrt4d4eAlbQbENEsJ
         rm1Q==
X-Gm-Message-State: AOAM530Qosu3UPL56I55FCG26EdNjheph4CpMZ4y6QWEfUgU9uzT2Wjr
        2buvku8hc3tffwPPpvlz+wQ7+XQN8PyUEjjY
X-Google-Smtp-Source: ABdhPJwWBBu+87lu3bYq2RrE/Sqnlc9DlQUMB4hrqNrFGaapPK8QPus4qi0ckowjzqSVvPlQt0zloA==
X-Received: by 2002:a17:902:7c14:b029:d4:d894:7eed with SMTP id x20-20020a1709027c14b02900d4d8947eedmr1042992pll.81.1602618542661;
        Tue, 13 Oct 2020 12:49:02 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u27sm462035pgm.60.2020.10.13.12.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 12:49:02 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
 <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
Date:   Tue, 13 Oct 2020 13:49:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 1:46 PM, Linus Torvalds wrote:
> On Mon, Oct 12, 2020 at 6:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Here are the io_uring updates for 5.10.
> 
> Very strange. My clang build gives a warning I've never seen before:
> 
>    /tmp/io_uring-dd40c4.s:26476: Warning: ignoring changed section
> attributes for .data..read_mostly
> 
> and looking at what clang generates for the *.s file, it seems to be
> the "section" line in:
> 
>         .type   io_op_defs,@object      # @io_op_defs
>         .section        .data..read_mostly,"a",@progbits
>         .p2align        4
> 
> I think it's the combination of "const" and "__read_mostly".
> 
> I think the warning is sensible: how can a piece of data be both
> "const" and "__read_mostly"? If it's "const", then it's not "mostly"
> read - it had better be _always_ read.
> 
> I'm letting it go, and I've pulled this (gcc doesn't complain), but
> please have a look.

Huh weird, I'll take a look. FWIW, the construct isn't unique across
the kernel.

What clang are you using?

-- 
Jens Axboe

