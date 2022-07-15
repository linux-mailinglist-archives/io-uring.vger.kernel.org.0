Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114B757671E
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 21:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiGOTHj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 15:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiGOTHj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 15:07:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48888558D4
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 12:07:37 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so12388066pjo.3
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 12:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1DTfeE5A1bnb7TqNe2D5/rOFMh5LFw9XWmN4c2V4D4o=;
        b=LHuXLKuiugUzcIMmgVXrz8fZX4ESHC2Zo4ut47ok6rHnGysWybHD7n9jrxNQYFWfLo
         rKWKlxas2b28d5UlKYXAJeSWsz2Hx6sdj/QQvBR4Pn3dElefmkjcgbL+35DUpDnSXSae
         WVTXvfsYwd8B2kMklNKCmuGdZswFfuUbgpzefjaII6w00pGRkahDx44dhkjMOg7XrUuR
         ekQN4U3/gHOoGDmykZy/J9JCO4ICYwGITVLuR4ocWY98thH4CgnZU8+XeZECR+04y556
         M/ddVOr+Hxw6QxNYErOQwKZi4DB+K1Di6eC1YJs5dzOwfhbg93AWEbHbQCmWBgQJIBej
         lyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1DTfeE5A1bnb7TqNe2D5/rOFMh5LFw9XWmN4c2V4D4o=;
        b=xI+AALB4hK1S/x4xocpm8yEA0bGh0jFDlI7SlOnsT5h14i39jTs7qcz+FjnvilvlWh
         s71yy5WUngrRF7I3ejIt3ASdtH2RLcoiUs0/uiUFWv+saoA9X9bw/1uB7SKAIFgMJzSr
         IP6w/7L6Tu1nLy1tR1Mb7A0nkaNC+rmXo3oHlN9X7ijoaS236LV5RAI3KZEOWvOWxq9Y
         RKvmR75fNpgwBmfkaZDdiKOZgHehJmj6NOS5SIVSVvPOpD0UxHp5e5ROM1A8G3ljo6XY
         sTetEmx2qE4YJu8qVU5tUtgemN3jXwP3UEKkX2x/jKHlA/WUkAdN0C6BmFymFuA2RLJs
         2BnQ==
X-Gm-Message-State: AJIora8uGrqxHjD7Z/gzOX/gRyThnvz5aTSJlD7YP9EknwmPXpYKPvxN
        XaCJgU0qtEa+14CRyWtQVRv6eg==
X-Google-Smtp-Source: AGRyM1uXa8d4qVxHxX1u+rPRA/TutFGvWMnHEELizN4taa8Ps5UofaKXFk7sTUCCjQfJePyaBUO1gQ==
X-Received: by 2002:a17:90a:9409:b0:1f0:e171:f2bd with SMTP id r9-20020a17090a940900b001f0e171f2bdmr8847935pjo.245.1657912056699;
        Fri, 15 Jul 2022 12:07:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902e84700b0016c1cdd2de3sm3937639plg.281.2022.07.15.12.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 12:07:36 -0700 (PDT)
Message-ID: <a91fdbe3-fe01-c534-29ee-f05056ffd74f@kernel.dk>
Date:   Fri, 15 Jul 2022 13:07:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>, casey@schaufler-ca.com
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/22 12:46 PM, Paul Moore wrote:
> On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
>>> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>>>
>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>> add infrastructure for uring-cmd"), this extended the struct
>>>> file_operations to allow a new command which each subsystem can use
>>>> to enable command passthrough. Add an LSM specific for the command
>>>> passthrough which enables LSMs to inspect the command details.
>>>>
>>>> This was discussed long ago without no clear pointer for something
>>>> conclusive, so this enables LSMs to at least reject this new file
>>>> operation.
>>>>
>>>> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>>>
>>> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
>>> v5.19-rcX releases, I'm going to be honest and say that I'm
>>> disappointed you didn't post the related LSM additions
>>
>> It does not mean I didn't ask for them too.
>>
>>> until
>>> v5.19-rc6, especially given our earlier discussions.]
>>
>> And hence since I don't see it either, it's on us now.
> 
> It looks like I owe you an apology, Luis.  While my frustration over
> io_uring remains, along with my disappointment that the io_uring
> developers continue to avoid discussing access controls with the LSM
> community, you are not the author of the IORING_OP_URING_CMD.   You
> are simply trying to do the right thing by adding the necessary LSM
> controls and in my confusion I likely caused you a bit of frustration;
> I'm sorry for that.

Maybe, just maybe, outbursts like this are why there's not a lot of
incentive to collaborate on this? I get why it can seem frustrating and
that you are being ignored, but I think it's more likely that people
just don't think of adding these hooks. I don't use any of the access
controls, nor do I really have a good idea which one exists and what
they do. None of the external developers or internal use cases we have
use any of this, and nobody outside of the developers of these kernel
features have ever brought it up...

I don't mind getting these added, but since I wasn't really part of
driving this particular feature, it wasn't on my radar.

>> Given a clear solution is not easily tangible at this point
>> I was hoping perhaps at least the abilility to enable LSMs to
>> reject uring-cmd would be better than nothing at this point.
> 
> Without any cooperation from the io_uring developers, that is likely
> what we will have to do.  I know there was a lot of talk about this
> functionality not being like another ioctl(), but from a LSM
> perspective I think that is how we will need to treat it.

Again this perceived ill intent. What are you looking for here?

>>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
 
> Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
> happening and it's unlikely the LSM folks are going to be able to
> influence the design/implementation much at this point so we have to
> do the best we can.  Given the existing constraints, I think your
> patch is reasonable (although please do shift the hook call site down
> a bit as discussed above), we just need to develop the LSM
> implementations to go along with it.
> 
> Luis, can you respin and resend the patch with the requested changes?
> 
> Casey, it looks like Smack and SELinux are the only LSMs to implement
> io_uring access controls.  Given the hook that Luis developed in this
> patch, could you draft a patch for Smack to add the necessary checks?
> I'll do the same for SELinux.  My initial thinking is that all we can
> really do is check the access between the creds on the current task
> (any overrides will have already taken place by the time the LSM hook
> is called) with the io_uring_cmd:file label/creds; we won't be able to
> provide much permission granularity for all the reasons previously
> discussed, but I suspect that will be more of a SELinux problem than a
> Smack problem (although I suspect Smack will need to treat this as
> both a read and a write, which is likely less than ideal).
> 
> I think it's doubtful we will have all of this ready and tested in
> time for v5.19, but I think we can have it ready shortly after that
> and I'll mark all of the patches for -stable when I send them to
> Linus.
> 
> I also think we should mark the patches with a 'Fixes:' line that
> points at the IORING_OP_URING_CMD commit, ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd").
> 
> How does that sound to everyone?

Let's do it the right way for 5.20, and then get it marked for a
backport. That will be trivial enough and will hit 5.19-stable shortly
as well. Rushing it now with 1 week before release will most likely
yield a worse long term result.

-- 
Jens Axboe

