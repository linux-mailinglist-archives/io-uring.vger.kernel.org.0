Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C234776775
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 20:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjHISiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 14:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjHISiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 14:38:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412F9210B;
        Wed,  9 Aug 2023 11:38:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 92F1C2185E;
        Wed,  9 Aug 2023 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691606296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jDo8u77rjiHYnBIYiW83NmXTq29Tjl9jGKLk7kPbjZQ=;
        b=xf9tgMF8nXpimEkm8g/Lf9VRRPvcI1zZvOFRN/a5+emvvQ4hzU+/F32J1g2GBGmhaYsD+X
        Vh9m9mWtXdQ2+CHO4xPxvTYf7Gk4V1NHJ/9Pmkhd+iI9IqVtMaoKclPeeGNl0kVRTH6Zja
        GNGkAa09uvtrVPT0YKK15T8tY8QiL1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691606296;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jDo8u77rjiHYnBIYiW83NmXTq29Tjl9jGKLk7kPbjZQ=;
        b=mxsYXXzNLRBzqc7rhbkLSlR/ygKG94FWAQw7kSub1YtD4rCw+FQaNKJbp+DNzzm+eUrNn9
        inYaGbDt+J7egUDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 55AC0133B5;
        Wed,  9 Aug 2023 18:38:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eCYpDxjd02RWHQAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 09 Aug 2023 18:38:16 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Andres Freund <andres@anarazel.de>
Cc:     Jeff Moyer <jmoyer@redhat.com>,
        Matteo Rizzo <matteorizzo@google.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring
 system-wide
In-Reply-To: <20230809150945.abp755qafjhxbmx6@awork3.anarazel.de> (Andres
        Freund's message of "Wed, 9 Aug 2023 08:09:45 -0700")
References: <20230630151003.3622786-1-matteorizzo@google.com>
        <20230630151003.3622786-2-matteorizzo@google.com>
        <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de>
        <x49fs5awiel.fsf@segfault.boston.devel.redhat.com>
        <20230809150945.abp755qafjhxbmx6@awork3.anarazel.de>
Date:   Wed, 09 Aug 2023 14:38:14 -0400
Message-ID: <87o7jg6oyx.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Andres Freund <andres@anarazel.de> writes:

> Hi,
>
> Sorry for the delayed response, EINBOXOVERFLOW.
>
> On 2023-07-26 16:02:26 -0400, Jeff Moyer wrote:
>> Andres Freund <andres@anarazel.de> writes:
>> 
>> > Hi,
>> >
>> > On 2023-06-30 15:10:03 +0000, Matteo Rizzo wrote:
>> >> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
>> >> or 2. When 0 (the default), all processes are allowed to create io_uring
>> >> instances, which is the current behavior. When 1, all calls to
>> >> io_uring_setup fail with -EPERM unless the calling process has
>> >> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
>> >> regardless of privilege.
>> >
>> > Hm, is there a chance that instead of requiring CAP_SYS_ADMIN, a certain group
>> > could be required (similar to hugetlb_shm_group)? Requiring CAP_SYS_ADMIN
>> > could have the unintended consequence of io_uring requiring tasks being run
>> > with more privileges than needed... Or some other more granular way of
>> > granting the right to use io_uring?
>> 
>> That's fine with me, so long as there is still an option to completely
>> disable io_uring.
>
> Makes sense.
>
>
>> > ISTM that it'd be nice if e.g. a systemd service specification could allow
>> > some services to use io_uring, without allowing it for everyone, or requiring
>> > to run services effectively as root.
>> 
>> Do you have a proposal for how that would work?
>
> I think group based permissions would allow for it, even if perhaps not in the
> most beautiful manner. Systemd can configure additional groups for a service
> with SupplementaryGroups, so adding a "io_uring" group or such should
> work.

This is more complex/requires more configuration than just blocking
root/non-root. Also, might not be practical for non-systemd systems, I
suspect. Can we keep the other options in the sysctl io_uring_disabled
as well:

0 -> all allowed (default)
1 -> group based permission
2 -> root only
3 -> all blocked

-- 
Gabriel Krisman Bertazi
