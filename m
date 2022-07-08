Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F147B56BFA1
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbiGHRsV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiGHRsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 13:48:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EC74365;
        Fri,  8 Jul 2022 10:48:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B4F391FE03;
        Fri,  8 Jul 2022 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657302498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MGXe0v3Tl84MztRDm5leQ1LnRMyfDzs9XQW01bhbKlw=;
        b=aG5BJxUrsjQUozD8+PQqaU5Yd0GTdG5Oh9CqK1pZeDaky85aet8ZF+rYJ1jBNw5p/4xDCS
        ZaoyAdABfP7TI8n/7iHt2S86i/EEYVp+QkZdmR/zdbnbXGx5c1GdwApGRsjX6UlCeY/ukc
        ttvWM1r2qymy+Sb3ITDZzzbiqb59afw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657302498;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MGXe0v3Tl84MztRDm5leQ1LnRMyfDzs9XQW01bhbKlw=;
        b=aF5J+aOAex0+90krDCgyIvZjULcJ+MCzF1LNGAqeETk7JJwraFG4K+l97oSwfoJw/+zxF6
        A3XcgK4cN2MtANAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E01713A80;
        Fri,  8 Jul 2022 17:48:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mmNYN+FtyGL3KgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 08 Jul 2022 17:48:17 +0000
Date:   Fri, 8 Jul 2022 14:48:15 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Fabian Ebner <f.ebner@proxmox.com>
Cc:     io-uring@vger.kernel.org, linux-cifs@vger.kernel.org,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: Re: Problematic interaction of io_uring and CIFS
Message-ID: <20220708174815.3g4atpcu6u6icrhp@cyberdelia>
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/08, Fabian Ebner wrote:
>(Re-sending without the log from the older kernel, because the mail hit
>the 100000 char limit with that)
>
>Hi,
>it seems that in kernels >= 5.15, io_uring and CIFS don't interact
>nicely sometimes, leading to IO errors. Unfortunately, my reproducer is
>a QEMU VM with a disk on CIFS (original report by one of our users [0]),
>but I can try to cook up something simpler if you want.
>
>Bisecting got me to 8ef12efe26c8 ("io_uring: run regular file
>completions from task_work") being the first bad commit.
>
>Attached are debug logs taken with Ubuntu's build of 5.18.6. QEMU trace
>was taken with '-trace luring*' and CIFS debug log was enabled as
>described in [1].
>
>Without CIFS debugging, the error messages in syslog are, for 5.18.6:
>> Jun 29 12:41:45 pve702 kernel: [  112.664911] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
>> Jun 29 12:41:46 pve702 kernel: [  112.796227] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.796250] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>> Jun 29 12:41:46 pve702 kernel: [  112.797781] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
>> Jun 29 12:41:46 pve702 kernel: [  112.798065] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
>> Jun 29 12:41:46 pve702 kernel: [  112.813485] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.813497] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>> Jun 29 12:41:46 pve702 kernel: [  112.826829] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.826837] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>> Jun 29 12:41:46 pve702 kernel: [  112.839369] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.839381] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>> Jun 29 12:41:46 pve702 kernel: [  112.851854] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.851867] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>> Jun 29 12:41:46 pve702 kernel: [  112.870763] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
>> Jun 29 12:41:46 pve702 kernel: [  112.870777] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5

It looks like this has something to do with multiple session setups on
the same channel, and there's a fix introduced in 5.19-rc1:

5752bf645f9 "cifs: avoid parallel session setups on same channel"

Can you build a test kernel with that commit and test it again? I
couldn't reproduce this with a small liburing test program. If you can
provide one, I'd be happy to take a deeper look at this bug.

Please note that the actual root cause of the error (CIFS needing
reconnect) is not very clear to me, but I don't have experience with
io_uring anyway:

178 Jun 29 11:25:39 pve702 kernel: [   87.439910] CIFS: fs/cifs/transport.c: signal is pending after attempt to send
179 Jun 29 11:25:39 pve702 kernel: [   87.439920] CIFS: fs/cifs/transport.c: partial send (wanted=65652 sent=53364): terminating session
180 Jun 29 11:25:39 pve702 kernel: [   87.439970] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
<cifs marks all sessions and tcons for reconnect and gets in the
erroneous reconnect loop as shown above>


Cheers,

Enzo
