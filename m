Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34328D705
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 01:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgJMXee (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 19:34:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54772 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgJMXee (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 19:34:34 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602632072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/YLDuvh8o8enL8QqTbIk9MoXqIrK4T+TFGRNdqoINP4=;
        b=WEnlE1kQ4MLaQs7L6tDWLxFdd7SIYrswalGTOed+lzfsXldS3U4lSykGTGimGLkP2iiCuo
        puXEkPCfudp1G2SM248dqYscfOQvZIIBx63AGDCpFQvHLT5HtQ3bFu6WunztNBfX7MQjhI
        eDHfMSiGdjMRV2keeFt5yDidfAp5W+FwaMoID3k/FDpFgyrL7MrQQsRNNAoOdlCPd0f2QN
        xzx+ncer5bo74ojU81ihp3Pz8+nGQZbRW7HoJP2l2wUwiSw6on0UgRNwcV8WE9UQsl9Y3y
        qtrMLSl2bvKQRxaNQSUwKDNoy38z9BCgd6cupvxSWF4VaoDPeLKX1Fpg5LPFvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602632072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/YLDuvh8o8enL8QqTbIk9MoXqIrK4T+TFGRNdqoINP4=;
        b=TYk5+iUil0CvGC5kQHsuhcAtBxU8suSFLGWDAAF/I6nM/37J4Oq5FuRFcYIFIGKQduNFzt
        ut6jgJNZDgbDmsDA==
To:     Jens Axboe <axboe@kernel.dk>, Miroslav Benes <mbenes@suse.cz>
Cc:     Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <3c3616f2-8801-1d42-6d7d-3dfbf977edb2@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk> <20201008145610.GK9995@redhat.com> <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz> <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk> <9a01ab10-3140-3fa6-0fcf-07d3179973f2@kernel.dk> <alpine.LSU.2.21.2010121921420.10435@pobox.suse.cz> <3c3616f2-8801-1d42-6d7d-3dfbf977edb2@kernel.dk>
Date:   Wed, 14 Oct 2020 01:34:32 +0200
Message-ID: <87lfg9og3b.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

On Tue, Oct 13 2020 at 13:39, Jens Axboe wrote:
> On 10/12/20 11:27 AM, Miroslav Benes wrote:
> I'm continuing to hone the series, what's really missing so far is arch
> review. Most conversions are straight forward, some I need folks to
> definitely take a look at (arm, s390). powerpc is also a bit hair right
> now, but I'm told that 5.10 will kill a TIF flag there, so that'll make
> it trivial once I rebase on that.

can you pretty please not add that to anything which is not going
through kernel/entry/ ?

The amount of duplicated and differently buggy, inconsistent and
incomplete code in syscall and exception handling is just annoying.

It's perfectly fine if we keep that #ifdeffery around for a while and
encourage arch folks to move over to the generic infrastructure instead
of proliferating the status quo by adding this to their existing pile.

The #ifdef guarding this in set_notify_signal() and other core code
places wants to be:

    #if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)

Thanks,

        tglx
