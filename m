Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5B77BFB9
	for <lists+io-uring@lfdr.de>; Mon, 14 Aug 2023 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjHNSXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 14:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjHNSXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 14:23:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92F10E3;
        Mon, 14 Aug 2023 11:23:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6980F1F383;
        Mon, 14 Aug 2023 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692037401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vrw+g1DBe8ZPV78sHOiS1djXqV9DnzvZjLoD8+5Ub/8=;
        b=tCmuTOXcY5U/WnmCUKer/o3hDR65mS9KZX9ZtaCZVD1M4PKlK6eSwMAyra3qbnEBIO81kf
        5jqqmE+q9GTbonNz8LouAmJNOhHg0pkkN2P6FyrGwoCR0gid3rCn8r4WHz8aeSpJWLEVjW
        kZevLYSXPMXWO472TSV5W2Rwr/0LVAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692037401;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vrw+g1DBe8ZPV78sHOiS1djXqV9DnzvZjLoD8+5Ub/8=;
        b=MTnMi+ayDLoRGG2sMGg+W6/qTl3tDCttR5vKQUFAkMSGCc5RCQOvn8p3WdUOGKtM+cZfqB
        L3cK/dc6qIRCIhBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 11D17138E2;
        Mon, 14 Aug 2023 18:23:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id H561Nxhx2mTAZQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 14 Aug 2023 18:23:20 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Andreas Hindborg <nmi@metaspace.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        German Maglione <gmaglione@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Joe Thornber <ethornbe@redhat.com>
Subject: Re: Libublk-rs v0.1.0
In-Reply-To: <ZNmX5UQev4qvFMaq@fedora> (Ming Lei's message of "Mon, 14 Aug
        2023 10:56:37 +0800")
References: <ZNmX5UQev4qvFMaq@fedora>
Date:   Mon, 14 Aug 2023 14:23:14 -0400
Message-ID: <87o7j95vql.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> Hello,
>
> Libublk-rs(Rust)[1][2] 0.1.0 is released.

Hi Ming,

Do you intend to effectively deprecate the code in ubdsrv in favor of
libublk-rs or do you intend to keep the C library?  I'm asking because
I'm looking into how to enable ublk in distributions.

Thanks,

>
> The original idea is to use Rust to write ublk target for covering all
> kinds of block queue limits/parameters combination easily when talking
> with Andreas and Shinichiro about blktests in LSFMM/BPF 2023.
>
> Finally it is evolved into one generic library. Attributed to Rust's
> some modern language features, libublk interfaces are pretty simple:
>
> - one closure(tgt_init) for user to customize device by providing all
>   kind of parameter
>
> - the other closure(io handling) for user to handling IO which is
>   completely io_uring CQE driven: a) IO command CQE from ublk driver,
>   b) target IO CQE originated from target io handling code, c) eventfd
>   CQE if IO is offloaded to other context
>
> With low level APIs, <50 LoC can build one ublk-null, and if high level
> APIs are used, 30 LoC is enough.
>
> Performance is basically aligned with pure C ublk implementation[3].
>
> The library has been verified on null, ramdisk, loop and zoned target.
> The plan is to support async/await in 0.2 or 0.3 so that libublk can
> be used to build complicated target easily and efficiently.
>
> Thanks Andreas for reviewing and providing lots of good ideas for
> improvement & cleanup. Thanks German Maglione for some suggestions, such
> as eventfd support. Thanks Joe for providing excellent Rust programming
> guide.
>
> Any feedback is welcome!
>
> [1] https://crates.io/crates/libublk 
> [2] https://github.com/ming1/libublk-rs
> [3] https://github.com/osandov/blktests/blob/master/src/miniublk.c
>
> Thanks,
> Ming
>

-- 
Gabriel Krisman Bertazi
