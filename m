Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D946EC8A7
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 11:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjDXJVX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 05:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjDXJVU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 05:21:20 -0400
Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A918F10C4;
        Mon, 24 Apr 2023 02:20:58 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8EF64821035;
        Mon, 24 Apr 2023 09:20:57 +0000 (UTC)
Received: from pdx1-sub0-mail-a207.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 09D8F820EED;
        Mon, 24 Apr 2023 09:20:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1682328057; a=rsa-sha256;
        cv=none;
        b=UKh2FHwa4Dlzrt2piIsvUgWs8eN93okAgK2eDKBBW0eG/0zzxSTHsgDbmo3/0+GYcqd5IY
        Jgh90Sm96qFxX5FE/BzQPpDpLrkY98yo+b6n4FFnRRTMg/N+0JMu/HHhNDZN4O+/cMCPvX
        qJmkH3woBDf3JVkREFqio9YDBhwVxzSSRv1XgP4hX4Ug8V5p4gKvrsHtPwLbihjT/mU87H
        1twW1NgcUiXYboeiv8LXzMIZTuQcnq22CWBYAPn/KSWH864udw+s/YIyul9eWfgBoZQCfg
        E7IzPqhFqJ0tYpTLU+4GVHD9kJy7k4mODmFdYn2quZkgAnVDdmuRp1dUVhrLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1682328057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=dFTksCPBklYyeO0qe+SmB5HBVs7ypW6/hxmTTDYRClI=;
        b=tI8fpMBY+fviYnPWavzlcPF40iTTMyb1QcKiBMPhKy5g3jhFvnOc6Ww2oCUf3/snuAVVU6
        R+73MCmZ3EQBecaLBzOhQW6gRomNTOMRVgE3RRd/oh+wgmpHxhl4j0CjY2ZQKmQy8NwPzP
        UdizsohTMALebIc9pOrSQNBX33/5Rl7cSqvI75jdJY5QkqY4Hj/PoYFW5Tf+BcxfLMxXBT
        hD2X/Vhx9dUtyLV38qlgsoITCofISnRUAK7RsM3FIIILWYib8EUWsAc8A799dmeU797kGD
        8NhFnL8Wno1uErtqDi83VBfj5sbc3KtopKpDML3l1ndUIpRyKz+hwPvNQ3ZTvA==
ARC-Authentication-Results: i=1;
        rspamd-548d6c8f77-hk64m;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=bugs@claycon.org
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Celery-Wipe: 7b9ac1932e539c02_1682328057391_2825378695
X-MC-Loop-Signature: 1682328057391:3806234663
X-MC-Ingress-Time: 1682328057391
Received: from pdx1-sub0-mail-a207.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.97.48.69 (trex/6.7.2);
        Mon, 24 Apr 2023 09:20:57 +0000
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a207.dreamhost.com (Postfix) with ESMTPSA id 4Q4fkc51x0zJF;
        Mon, 24 Apr 2023 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=claycon.org;
        s=dreamhost; t=1682328056;
        bh=dFTksCPBklYyeO0qe+SmB5HBVs7ypW6/hxmTTDYRClI=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=ZYtLkz7b40TS9uIuptBvrL3aRUyKw8PTfNMUcdM//Y6Gou9nCqL1uAZgqgTRr6OTI
         wPYue2ZOwcyDChtazIGDLO8o8VBz0I7yuPfVh01yW0fEVPwRvEvxtZCw67Gfct6LXV
         gJYymfcWlrbvwxL655zNoHi8ZCsAZ1/JCgB9j83Vawkt894u7SgpKa7VphKd4K/QWl
         YoAAd//zWFYrXYOrSvUueef0P6aEhXDvUcxEEvDsNZj7gZgncFc9PCyVb+erWb9WFP
         9JMzsxBakvdvK2OC8HXJr/XBZ5w+w/rLkk0aXts9jUj5LH0Xb1PPlnJkJuoH0KiIX+
         TMTDf63DtoILA==
Date:   Mon, 24 Apr 2023 04:20:55 -0500
From:   Clay Harris <bugs@claycon.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230424092054.q6iiqqnrohenr5d2@ps29521.dreamhostps.com>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230424072946.uuzjvuqrch7m4zuk@ps29521.dreamhostps.com>
 <ZEZArsLzVZnSMG_o@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZArsLzVZnSMG_o@codewreck.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 24 2023 at 17:41:18 +0900, Dominique Martinet quoth thus:

> Thanks!
> 
> Clay Harris wrote on Mon, Apr 24, 2023 at 02:29:46AM -0500:
> > This also seems like a good place to bring up a point I made with
> > the last attempt at this code.  You're missing an optimization here.
> > getdents knows whether it is returning a buffer because the next entry
> > won't fit versus because there are no more entries.  As it doesn't
> > return that information, callers must always keep calling it back
> > until EOF.  This means a completely unnecessary call is made for
> > every open directory.  In other words, for a directory scan where
> > the buffers are large enough to not overflow, that literally twice
> > as many calls are made to getdents as necessary.  As io_uring is
> > in-kernel, it could use an internal interface to getdents which would
> > return an EOF indicator along with the (probably non-empty) buffer.
> > io_uring would then return that flag with the CQE.
> 
> Sorry I didn't spot that comment in the last iteration of the patch,
> that sounds interesting.
> 
> This isn't straightforward even in-kernel though: the ctx.actor callback
> (filldir64) isn't called when we're done, so we only know we couldn't
> fill in the buffer.
> We could have the callback record 'buffer full' and consider we're done
> if the buffer is full, or just single-handedly declare we are if we have
> more than `MAXNAMLEN + sizeof(struct linux_dirent64)` left over, but I
> assume a filesystem is allowed to return what it has readily available
> and expect the user to come back later?
> In which case we cannot use this as an heuristic...
> 
> So if we do this, it'll require a way for filesystems to say they're
> filling in as much as they can, or go the sledgehammer way of adding an
> extra dir_context dir_context callback, either way I'm not sure I want
> to deal with all that immediately unless I'm told all filesystems will
> fill as much as possible without ever failing for any temporary reason
> in the middle of iterate/iterate_shared().

I don't have a complete understanding of this area, but my thought was
not that we would look for any buffer full condition, but rather that
an iterator could be tested for next_entry == EOF.

> Call me greedy but I believe such a flag in the CQE could also be added
> later on without any bad side effects (as it's optional to check on it
> to stop calling early and there's no harm in not setting it)?

Certainly it could be added later, but I wanted to make sure some thought
was put into it now.  It would be nice to have it sooner rather than later
though...

> 
> > (* As an aside, the only place I've ever seen a non-zero lseek on a
> > directory, is in a very resource limited environment, e.g. too small
> > open files limit.  In the case of a depth-first directory scan, it
> > must close directories before completely reading them, and reopen /
> > lseek to their previous position in order to continue.  This scenario
> > is certainly not worth bothering with for io_uring.)
> 
> (I also thought of userspace NFS/9P servers are these two at least get
> requests from clients with an arbitrary offset, but I'll be glad to
> forget about them for now...)
> 
> -- 
> Dominique Martinet | Asmadeus
