Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0616200DA
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 22:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiKGVRs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 16:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiKGVRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 16:17:32 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8E81EEF6
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 13:13:37 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q186so1143619oia.9
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 13:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pHms/O+9VBq8irGp3MyiuJlyANLL/CCV2NFYd5lytyA=;
        b=fbz0dJ0XnDpsx+hMge6yfECCLrQ9kRAHBi+2sKrgralxQwXVYVPHT1wlH0vOI9aXS8
         Q69Cl3BJx4YPMF4NRILvqzetKOldQMWspeGTkz0lcPKpFBHfezWWbmdr/ZwTypsvUFdJ
         g5J3srFyn2ZUZP5+9zDAEtyqAlGXF0vIdYcpbhgL85wp04jFhnedzI1rRnmZjWbn6RAL
         mYWri7hGGN55fKqX+3zh9NzgGpFjgaC7vxXACDyVgFcJ4ZkzpfW7oo1SQYpXUBAmPu8Y
         6jkwwIrJAv0O2KHOkdhSm95DZ/t0cfAUEvg9DHWvzYQvYg8crJo1G2MC38vRRwBc4bkh
         4FhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHms/O+9VBq8irGp3MyiuJlyANLL/CCV2NFYd5lytyA=;
        b=j6Kelj/efzj8WDLbV13RSeNGJvD8w+X3MxPyovGYsj+KCjI1z9EghlQ2lYfzahe4uv
         W8YugKvdaIMmiK+RzZYHEhjY7MQMOjV30D/5tozoAZ4fuBCkVq9GFp+iemoMtUeJWnI0
         8msadmcgZ2B0NO6ZQm/+bpFl/a9F8dRLvzGdoJGqcmxi0V02tODQ3feDidl0/Ldialyx
         1Z7GfqOgzV2gUJRZrRbQ0bDs5JCfTqun0T7OW+v/IIaW2tBZvYvtVZP2SqxzlZuyCw7g
         OXNzM9JkDBEzzr3m2GFLBkc1gyL/m1T93yC0PGJAFXFxxVj/pASVOny8MPt734Jzvcf3
         XFxQ==
X-Gm-Message-State: ACrzQf2Gu/oOQbN5r3TMC04jA5CGOQKOM9+25+hzXgrrx0VHtKla4g5w
        vwM5i49v5+/OV+GzouHQb0AZOx7/vYece91iPqt5
X-Google-Smtp-Source: AMsMyM4KnQnz9BbylEC8a4qKc19JcYPq3m7VWW4QnZi9Gv86OMlxbUuEIKo61OnWavUhJ9RvHyxDno+RIArn4c7OBDc=
X-Received: by 2002:a05:6808:1441:b0:35a:4a2d:673b with SMTP id
 x1-20020a056808144100b0035a4a2d673bmr14688971oiv.172.1667855616463; Mon, 07
 Nov 2022 13:13:36 -0800 (PST)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com>
In-Reply-To: <20221107205754.2635439-1-cukie@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 7 Nov 2022 16:13:25 -0500
Message-ID: <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
To:     Gil Cukierman <cukie@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
>
> This patchset provides the changes required for controlling access to
> the io_uring_setup system call by LSMs. It does this by adding a new
> hook to io_uring. It also provides the SELinux implementation for a new
> permission, io_uring { setup }, using the new hook.
>
> This is important because existing io_uring hooks only support limiting
> the sharing of credentials and access to the sensitive uring_cmd file
> op. Users of LSMs may also want the ability to tightly control which
> callers can retrieve an io_uring capable fd from the kernel, which is
> needed for all subsequent io_uring operations.

It isn't immediately obvious to me why simply obtaining a io_uring fd
from io_uring_setup() would present a problem, as the security
relevant operations that are possible with that io_uring fd *should*
still be controlled by other LSM hooks.  Can you help me understand
what security issue you are trying to resolve with this control?

-- 
paul-moore.com
