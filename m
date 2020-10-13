Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3228D620
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 23:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgJMVGG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 17:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgJMVGG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 17:06:06 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EDBC061755;
        Tue, 13 Oct 2020 14:06:05 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t12so2327971ilh.3;
        Tue, 13 Oct 2020 14:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C97h+MRq5l70WYEeMsIQX2bPmyCE0QOE/Kr9SYmuEek=;
        b=KQWyBL1B41rVXjsLWnmDO1jACfL2V7+8oLCS+mIdRxZHu+3UO/xKbs6/31FwUSQouW
         3KLhYVndnILQx7Nh1uuKPyF8gfAL6s5H4WxAclBP+MjMr8QV03c5jwaCndPXEIeOLYlT
         XqfBdE97RWtX6ULuJwnzhmZTSvmRrqXYtvYK/i+gGOUxtYUDnFVb8CJTJh+FHPYBdNRC
         XJWrh7qzdDtKj9pbmQsq2X/6FvMUxeBTF/zZDyLfkYMlsKZBUlF602p1NGu2PTbQg4MB
         17VB0huzr9Gc+9vCPUIakgKoecW7ZW1FZw/tzWwd1xu5XAAebJJ3SWwz72NlUiEocINj
         /bkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=C97h+MRq5l70WYEeMsIQX2bPmyCE0QOE/Kr9SYmuEek=;
        b=uh90g5gAHOJD2SC6nj5ad2YoiyHqsSgMzSy/DiivIknHN95ZljgC1QKA4Mjua7TnKs
         Saqb0KY6ltuRQNsdiPGDXFZHI6Ko3hMbzHrWRWE/7KqZbOhz4pxj+FHRzNTZN8d7xRHl
         al3XgaJs8lL3F2z+x9pU7xkRXyFV8o1xGVmocbV0tKIsdTwJTSaQcXmfm2/nRJZ0WBvq
         EKAbiXmhCktuEBD70gD6Iev9dZswaCpPL6ZWeomJIGxWYYtahPxM+s8UIQYV9ZJt4q+V
         dKwIVVx8m5kxLYBtS23TtVMy2u2bbiPVhVDBvaWXU4opbSiMi6vU4S0LPs38or6iVtQR
         TdKw==
X-Gm-Message-State: AOAM532nE2YlAXOkvwuM2xlHiOZS7iSKAFlTj8GYsAzaO4Z7E26BfEG5
        +RKw1Uu7KApoxMh1K1+/cAhpw/1sA/SKxQ==
X-Google-Smtp-Source: ABdhPJxLMtd+8d4/MGijYt4mmj6QqmasAOS6bXUzHb1bvZ3sD09AhUUGlI2RMcuTnn639csE3kcmhg==
X-Received: by 2002:a05:6e02:ef4:: with SMTP id j20mr1466194ilk.195.1602623164229;
        Tue, 13 Oct 2020 14:06:04 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id q196sm929652iod.17.2020.10.13.14.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 14:06:03 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 13 Oct 2020 17:06:02 -0400
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
Message-ID: <20201013210602.GA1466033@rani.riverdale.lan>
References: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
 <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
 <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 13, 2020 at 01:49:01PM -0600, Jens Axboe wrote:
> On 10/13/20 1:46 PM, Linus Torvalds wrote:
> > On Mon, Oct 12, 2020 at 6:46 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Here are the io_uring updates for 5.10.
> > 
> > Very strange. My clang build gives a warning I've never seen before:
> > 
> >    /tmp/io_uring-dd40c4.s:26476: Warning: ignoring changed section
> > attributes for .data..read_mostly
> > 
> > and looking at what clang generates for the *.s file, it seems to be
> > the "section" line in:
> > 
> >         .type   io_op_defs,@object      # @io_op_defs
> >         .section        .data..read_mostly,"a",@progbits
> >         .p2align        4
> > 
> > I think it's the combination of "const" and "__read_mostly".
> > 
> > I think the warning is sensible: how can a piece of data be both
> > "const" and "__read_mostly"? If it's "const", then it's not "mostly"
> > read - it had better be _always_ read.
> > 
> > I'm letting it go, and I've pulled this (gcc doesn't complain), but
> > please have a look.
> 
> Huh weird, I'll take a look. FWIW, the construct isn't unique across
> the kernel.
> 
> What clang are you using?
> 
> -- 
> Jens Axboe
> 

If const and non-const __read_mostly appeared in the same file, both gcc
and clang would give errors.
