Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6544859EB35
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiHWSje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiHWSjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:39:12 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E4A1151CB
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:02:34 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id j5so16743709oih.6
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NGK9SJL+jbcJ+81jw1EQdQeIyg8FgfHLJJZwNUv48rA=;
        b=yMYBIle+g6JQATabokr1qmPm7dB1NceXKHg1qSJ5mVkoCQVYkYZ4hVMkQI79lRSrbM
         UgzU23MM2hR74US26qOSr7XfbWiecTCCWcfLRSQSZITmmjAX4bDBXL5UOJ9XVcpkVH3X
         wBbXBZWE4oQYgc7La98gH9Pl3GLjL1MoT9GvIo/AIt3DgFRGO83kCX0/qvvKVDc7sNeL
         yAxIJO33R6IRH+o41c/P36Om9BtL7bpMd9l8g2TGv0HGArcC83+3tzk1vAodic3OnmnL
         kid9cx5Xdbz5o6MF5LSVSoVL6WfLxCbUbC9okv8NmnK+kpsSxBbDpWjEIt9HHr1anyNe
         RE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NGK9SJL+jbcJ+81jw1EQdQeIyg8FgfHLJJZwNUv48rA=;
        b=Rkihg3GurzcAcbG3hHSKucDN78TJOm6Xyq1mWYjjh1ARITfbxZ6w2mW4Ha/rHfdzk7
         l+0EP1piDV4yIOHC0+WaKye5GsT3SYr/7f+TJMMDYdHzrvs2qCMVRMSDKswsbx0h2qGx
         A4pTpgS3v0BilusQXU6EkSyEi5QddzWu6RG675Xr84vf9vfJYclC9dSPqDo7f2zU6lvv
         cTl+pEcUw4WHuC14gschZddXA9KpHpXvi7nU/3MRaKrUVSVAYPavucYC3cJp0UlVE2HJ
         OY/CvmW8yhpqOtyuDLzGDdpl0h7mObK+kJvt8OteVdh0cO+vm5bM4xfPihh72iwes3be
         s//A==
X-Gm-Message-State: ACgBeo0GAMDy0nWzur3CbN1PIGHJ0MvhXEqXuM8N0qqBAfoFdkf5zks3
        a/Se+34OPCT8UXQD4U61yNLuP6I+MevBsjb/3A73
X-Google-Smtp-Source: AA6agR53O11aV/ezRM7BbFUHuJcDs3a0pSzF9hsHKGQhOx8rTVzKkK7KIbQ/aKwEaca9cTWClNVOcM6dTYZLjdSjdCs=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr1714816oif.136.1661274139335; Tue, 23
 Aug 2022 10:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly> <YwR5HBazPxWjcYci@kroah.com>
In-Reply-To: <YwR5HBazPxWjcYci@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Aug 2022 13:02:08 -0400
Message-ID: <CAHC9VhQOSr_CnLmy0pwgUETPh565951DdejQtgkfNk7=tj+BNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 2:52 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> > This patch adds support for the io_uring command pass through, aka
> > IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> > /dev/null functionality, the implementation is just a simple sink
> > where commands go to die, but it should be useful for developers who
> > need a simple IORING_OP_URING_CMD test device that doesn't require
> > any special hardware.
>
> Also, shouldn't you document this somewhere?
>
> At least in the code itself saying "this is here so that /dev/null works
> as a io_uring sink" or something like that?  Otherwise it just looks
> like it does nothing at all.

What about read_null() and write_null()?  I can definitely add a
comment (there is no /dev/null documentation in the kernel source tree
that I can see), but there is clearly precedence for /dev/null having
"do nothing" file_operations functions.  If nothing else, it's pretty
much in the *name*; we're adding the "uring_cmd_null()" member
function to the "null_fops" struct for the "null" device ... come on
Greg :)

-- 
paul-moore.com
