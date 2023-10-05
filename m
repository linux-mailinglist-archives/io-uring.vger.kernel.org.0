Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FDB7BA2E1
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbjJEPsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Oct 2023 11:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjJEPsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Oct 2023 11:48:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84866EB1
        for <io-uring@vger.kernel.org>; Thu,  5 Oct 2023 07:25:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 446C22185F;
        Thu,  5 Oct 2023 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696515916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbCL1IhLGk0bvhVf5OYmihjQgPje9k7sZFwHJfuIZF8=;
        b=DbJ9+B4DYnSE2CzvpOPdegH8tN67mCHJBGfktLzSCJpHgRRith3czzFAur1dEslAyEjtrx
        8RIsY17/ltUKOH01HVNUGU7cHkErYnmeU5ct+NqpzZGPohEUbqjBnx+OzChurrrTgvkhEH
        mcoztaKPVSfmytAAOWGdoO7WUSnXRFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696515916;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbCL1IhLGk0bvhVf5OYmihjQgPje9k7sZFwHJfuIZF8=;
        b=+aseZbZUW87blQaxgPmyRQJJ3G2ItOEH3NGpnS2snie7PxmsOlnidR+JqhPTzldoGCe2c7
        jHmp5W8FVvbVrVDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 117E0139C2;
        Thu,  5 Oct 2023 14:25:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MAdeOkvHHmUWLgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 05 Oct 2023 14:25:15 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 0/3] trivial fixes and a cleanup of provided buffers
In-Reply-To: <2b5d884b-9709-4219-88bc-47840f62ff46@kernel.dk> (Jens Axboe's
        message of "Wed, 4 Oct 2023 20:18:26 -0600")
Organization: SUSE
References: <20231005000531.30800-1-krisman@suse.de>
        <2b5d884b-9709-4219-88bc-47840f62ff46@kernel.dk>
Date:   Thu, 05 Oct 2023 10:25:14 -0400
Message-ID: <87pm1t2lkl.fsf@suse.de>
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

Jens Axboe <axboe@kernel.dk> writes:

> On 10/4/23 6:05 PM, Gabriel Krisman Bertazi wrote:
>> Jens,
>> 
>> I'm resubmitting the slab conversion for provided buffers with the
>> suggestions from Jeff (thanks!) for your consideration, and appended 2
>> minor fixes related to kbuf in the patchset. Since the patchset grew
>> from 1 to 3 patches, i pretended it is not a v2 and restart the
>> counting from 1.
>
> Thanks, this looks good. For patches 1-2, do you have test cases you
> could send for liburing?

Sure. I'll adapt them to liburing and submit shortly.

-- 
Gabriel Krisman Bertazi
