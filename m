Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32C56C667
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 05:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiGIDbI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 23:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGIDbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 23:31:07 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4487E838;
        Fri,  8 Jul 2022 20:31:06 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id r2so528984qta.0;
        Fri, 08 Jul 2022 20:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRFhd4OeJi3YTFC9I8fJ+KstWMLDw9NSm+tnDDqyVNI=;
        b=PmLVTe29TOGi9EsH74PK/kY7GvV3zab2ySRi8/MxYAN1uUu4TToJBNo7jyd7ZiczP2
         qPE5KMO+Ih+m1jQQAHErgbQ4NngNScwXtHQoAP1SnjctMhDZ1F7M/xE+f0HtJa3A6hyz
         r9m+f+8Lkps6+UWeSPyUB5BnP0T9nYDPA+mVN3sDerEfRCUdHyu1ct/1YXhoo7PDNMeC
         2G/9OeJX7fIfv+CEz0lLaFwcRKZ7LrIY7O7CCTMQE6bbLK5nZWcmlxp1TENYunZ6Bj/C
         lmymV5owtDTCAI++fbIJqoxQvKrOsvPSMpJSpytnbcDYkGK7atE/25i6/2ygDIksCRFp
         jxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRFhd4OeJi3YTFC9I8fJ+KstWMLDw9NSm+tnDDqyVNI=;
        b=uSV7E9q8BPSf25lWdl44BD0Uf8eSioFDKgSHxrMl1zQ5cf5r6QmE9TXoaFvUkdUasr
         f++k4tM17P0JinkppGw6wx1+lD0mf/AMx7ULfEnYBgOqlPNKbmVe82MtBUZORiWEmfX9
         AdvX+h9l5rCOC0qS910S1FDzpoxFVV7Xeu+9l/GoX6tqrA7OXu0Xu8DNcLMSpxBoBsEl
         io7qAcjyrCWUrykl6QmVN0xe1WSuK1UCrj8k1L/RLwf2Bi5IES92CfSLc7vr/FVNgPiP
         eA+qQ9lIBhpkr9hWTCvrDscWKXvj/DQR/1h44wvKAMgT7x5j1jCuJL+JOpNxi1PJwt5E
         hczg==
X-Gm-Message-State: AJIora8SHyyN+8M2SRrSTFDEIsi79SzeheFd44pp+6l0f+Aslbq0+ZFL
        NzaYg9mGL7gZYPTuyhIAoNvSwZ+cZT+48en0T3pdvl1ZEy5bxXGc
X-Google-Smtp-Source: AGRyM1tzT7d5vkK4YLLyw2FKjwXz+JoasayjU/Z4RZnBiuxquMzfLckLKigKjJn01If4RsNoUgYFlYVCCrZdX9FSNP4=
X-Received: by 2002:ac8:7fce:0:b0:31d:34bd:66b4 with SMTP id
 b14-20020ac87fce000000b0031d34bd66b4mr5680265qtk.673.1657337465760; Fri, 08
 Jul 2022 20:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com> <20220708174815.3g4atpcu6u6icrhp@cyberdelia>
In-Reply-To: <20220708174815.3g4atpcu6u6icrhp@cyberdelia>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 9 Jul 2022 09:00:58 +0530
Message-ID: <CANT5p=rSKRe_EXFmKS+qRyBo4i9Ko1pcgwxy-B1gugJtKjVAMA@mail.gmail.com>
Subject: Re: Problematic interaction of io_uring and CIFS
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Fabian Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 8, 2022 at 11:22 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 07/08, Fabian Ebner wrote:
> >(Re-sending without the log from the older kernel, because the mail hit
> >the 100000 char limit with that)
> >
> >Hi,
> >it seems that in kernels >= 5.15, io_uring and CIFS don't interact
> >nicely sometimes, leading to IO errors. Unfortunately, my reproducer is
> >a QEMU VM with a disk on CIFS (original report by one of our users [0]),
> >but I can try to cook up something simpler if you want.
> >
> >Bisecting got me to 8ef12efe26c8 ("io_uring: run regular file
> >completions from task_work") being the first bad commit.
> >
> >Attached are debug logs taken with Ubuntu's build of 5.18.6. QEMU trace
> >was taken with '-trace luring*' and CIFS debug log was enabled as
> >described in [1].
> >
> >Without CIFS debugging, the error messages in syslog are, for 5.18.6:
> >> Jun 29 12:41:45 pve702 kernel: [  112.664911] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
> >> Jun 29 12:41:46 pve702 kernel: [  112.796227] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.796250] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >> Jun 29 12:41:46 pve702 kernel: [  112.797781] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
> >> Jun 29 12:41:46 pve702 kernel: [  112.798065] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
> >> Jun 29 12:41:46 pve702 kernel: [  112.813485] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.813497] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >> Jun 29 12:41:46 pve702 kernel: [  112.826829] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.826837] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >> Jun 29 12:41:46 pve702 kernel: [  112.839369] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.839381] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >> Jun 29 12:41:46 pve702 kernel: [  112.851854] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.851867] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >> Jun 29 12:41:46 pve702 kernel: [  112.870763] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> >> Jun 29 12:41:46 pve702 kernel: [  112.870777] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
>
> It looks like this has something to do with multiple session setups on
> the same channel, and there's a fix introduced in 5.19-rc1:
>
> 5752bf645f9 "cifs: avoid parallel session setups on same channel"
>
> Can you build a test kernel with that commit and test it again? I
> couldn't reproduce this with a small liburing test program. If you can
> provide one, I'd be happy to take a deeper look at this bug.
>
> Please note that the actual root cause of the error (CIFS needing
> reconnect) is not very clear to me, but I don't have experience with
> io_uring anyway:
>
> 178 Jun 29 11:25:39 pve702 kernel: [   87.439910] CIFS: fs/cifs/transport.c: signal is pending after attempt to send
> 179 Jun 29 11:25:39 pve702 kernel: [   87.439920] CIFS: fs/cifs/transport.c: partial send (wanted=65652 sent=53364): terminating session
> 180 Jun 29 11:25:39 pve702 kernel: [   87.439970] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
> <cifs marks all sessions and tcons for reconnect and gets in the
> erroneous reconnect loop as shown above>
>
>
> Cheers,
>
> Enzo

Hi Fabian,

It looks like the server is rejecting new binding session requests
with STATUS_REQUEST_NOT_ACCEPTED.
Are you saying that the issue is specific to 5.15+ kernel, and the
issue doesn't happen on older kernels?
Also, what server are you using? Has that changed across these attempts?

Can you please dump the output of:
cat /proc/fs/cifs/DebugData
when the issue is happening?

-- 
Regards,
Shyam
