Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2C67F1FC
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjA0XFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjA0XFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:05:33 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E68217CC5
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:05:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10130848pjq.0
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1if3nqY3ebhaiRdRKG+YvG1GCcwT1XGQ5ycqjx8peko=;
        b=vSe7FfCCbaXgIKee2fJGuBa/QQtO750Y5RWFfwooLvsW/TIQMHubSSDl/MpiQq/Dgg
         48wQXYBRZrnCkvCirfc4/tiH8r0bEfF0TDTvZuIdGd0/AJ54cTfUpS/FebzLWBSvA70U
         pSelnlf2ysvGnc30HFu6S5ZBdRtQfMymkm8mgQLjtfi6HYhy7NC8l+nCG5C+QgExsVoz
         OoJk9GhgQkjXUQdmKLihir5GghQQKI5KVGMXAAsHoItqIHXaRp5bGg+i0D4sErAuamtL
         7OOmgZILljUYfH1DFR2TO4Xa+1OuYib6jv3sKSsQ4W5OE8pPWP1SdiiyKlQrsNMzvWp9
         EtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1if3nqY3ebhaiRdRKG+YvG1GCcwT1XGQ5ycqjx8peko=;
        b=ttvC6np+jTyIn+5pWTercg5epAkVKFQ3GUKdKvvHgPc0LXZ+/u2NDVF+yZpdhdhlQh
         kUlG1otKGWDGn+U5qPlgbXl8RFultXVlqYRmnfOUOoB+0rqSA9IlLiy5+DWuZ4pqwIjW
         /iZvF7zLAmFY9aWwBM0tKW0wQBvCDx/+9MZz7YotIXHhIJRqRTC+UnvKaXVOMDm9/Zkx
         /o7KFG2X7b7d5M+V9JqW9EODLa499epGoeODjIr5gkBQudysQjSb2M9fw5qa0LkIuRSX
         v7Q9pY39nc3eSu4pTJWr6pDdxO4nqIxYZeFkyXY6hztaX46pl+B/PTmhgKvjecY59WDZ
         7fvA==
X-Gm-Message-State: AFqh2koo3b0AJGB4n0NtizN9D2Bahw3SUm73idz8TGJmANfmXgjgqu72
        rzyaP6FPYQJnym9ZnXwLCQHrlw==
X-Google-Smtp-Source: AMrXdXvMBrteWfxyFIiiCzWxki5bIZfpsTdo2LgDYcI1fhYZ9PoPBVh+itd57y3ta5hGLDjuOdr1LA==
X-Received: by 2002:a05:6a20:429e:b0:b5:f664:b4bc with SMTP id o30-20020a056a20429e00b000b5f664b4bcmr13388200pzj.2.1674860731663;
        Fri, 27 Jan 2023 15:05:31 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t16-20020a639550000000b0046fefb18a09sm2742146pgn.91.2023.01.27.15.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 15:05:31 -0800 (PST)
Message-ID: <5270af37-5544-42de-4e3f-c437889944dd@kernel.dk>
Date:   Fri, 27 Jan 2023 16:05:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
Content-Language: en-US
To:     Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com>
 <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y9RX0QhHKfWv3TGL@madcap2.tricolour.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 4:01 PM, Richard Guy Briggs wrote:
> On 2023-01-27 17:43, Paul Moore wrote:
>> On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>> Getting XATTRs is not particularly interesting security-wise.
>>>
>>> Suggested-by: Steve Grubb <sgrubb@redhat.com>
>>> Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
>>> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>>> ---
>>>  io_uring/opdef.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>
>> Depending on your security policy, fetching file data, including
>> xattrs, can be interesting from a security perspective.  As an
>> example, look at the SELinux file/getattr permission.
>>
>> https://github.com/SELinuxProject/selinux-notebook/blob/main/src/object_classes_permissions.md#common-file-permissions
> 
> The intent here is to lessen the impact of audit operations.  Read and
> Write were explicitly removed from io_uring auditing due to performance
> concerns coupled with the denial of service implications from sheer
> volume of records making other messages harder to locate.  Those
> operations are still possible for syscall auditing but they are strongly
> discouraged for normal use.
> 
> If the frequency of getxattr io_uring ops is so infrequent as to be no
> distraction, then this patch may be more of a liability than a benefit.

(audit list removed)

Right now the xattr related functions are io-wq driven, and hence not
super performance sensitive. But I'd greatly prefer to clean these up
regardless, because once opcodes get upgraded from needing io-wq, then
we don't have to go through the audit discussion at that point. Better
to do it upfront, like now, regardless of expectation of frequency of
calls.

-- 
Jens Axboe


