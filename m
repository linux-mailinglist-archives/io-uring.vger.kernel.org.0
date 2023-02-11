Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA826930C8
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 13:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBKMGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 07:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKMGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 07:06:43 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E282FCFF;
        Sat, 11 Feb 2023 04:06:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B07645D511;
        Sat, 11 Feb 2023 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676117200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KP5yy1ZpwWkRzlaqj8fbu7lqqI4sZIjJJyvGJl92ICE=;
        b=NJPGzvbYh3oTdV5a6oBqeiHxCosJwJPz9/mOLIfh18z09End4DbwW5SJdouu0ILz5CJV12
        clfQzgJHB6QG0h+X0c7VwXUqKaT1FeHEcBxJjHK+m42AgkXm110NqKkNzzevLfv3zhrpi7
        W4EwKeBQCj9rn2Dn50cTai7hGgAqgVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676117200;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KP5yy1ZpwWkRzlaqj8fbu7lqqI4sZIjJJyvGJl92ICE=;
        b=U0NL6JPqPuTL8hiRN3SVVvrSEy29wDuJ6zC9OqCxAMM9pZILZX+zx0SGsplJx5RSrfyPU4
        SiNrEqQDW86yApBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 70E3313A10;
        Sat, 11 Feb 2023 12:06:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HYO/GtCE52OoXAAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 11 Feb 2023 12:06:40 +0000
Message-ID: <87bd6050-d7df-94f6-bfc1-6ddac79d6d65@suse.de>
Date:   Sat, 11 Feb 2023 13:06:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230210180033.321377-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 19:00, Kanchan Joshi wrote:
> is getting more common than it used to be.
> NVMe is no longer tied to block storage. Command sets in NVMe 2.0 spec
> opened an excellent way to present non-block interfaces to the Host. ZNS
> and KV came along with it, and some new command sets are emerging.
> 
> OTOH, Kernel IO advances historically centered around the block IO path.
> Passthrough IO path existed, but it stayed far from all the advances, be
> it new features or performance.
> 
> Current state & discussion points:
> ---------------------------------
> Status-quo changed in the recent past with the new passthrough path (ng
> char interface + io_uring command). Feature parity does not exist, but
> performance parity does.
> Adoption draws asks. I propose a session covering a few voices and
> finding a path-forward for some ideas too.
> 
> 1. Command cancellation: while NVMe mandatorily supports the abort
> command, we do not have a way to trigger that from user-space. There
> are ways to go about it (with or without the uring-cancel interface) but
> not without certain tradeoffs. It will be good to discuss the choices in
> person.
> 
I would love to have this discussion; that's something which has been on 
my personal to-do list for a long time, and io_uring might finally be a 
solution to it.

Or, alternatively, looking at CDL for NVMe; that would be an alternative 
approach.
Maybe it's even worthwhile to schedule a separate meeting for it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

