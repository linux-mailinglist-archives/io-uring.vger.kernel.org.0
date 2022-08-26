Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA545A2FB3
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 21:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiHZTKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345370AbiHZTK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 15:10:27 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754F8248C6
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 12:10:24 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u14so3098650oie.2
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 12:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=P1oNGKHauoarsefVawtt6JeTu2BppdpNv8SCIMcY6ik=;
        b=D9NZQKooe1VVQMxGeazEryhCEXxOk77aMfNvbfa/W4sw0n8+lQCLMWySlzUNyKIUCt
         +1S2Fip6P9hv2M5V5p9fpB6v6ymNc6HNpe4PLg9c9AY6e+jxoS6/+ciTuAojmb0cFPIW
         VyoVoFOL0BYIXarH7A4fWMC+zrmVxBoZ/E2T32lmvpxtRVU6GIGU9FLab7luwo0HRcBK
         Ua9McOYTmETa226shUywwCrei1EPbq/w06PBKmIaLoYfB7QhwKzMPzi2TKMtjt9nkxSA
         CWKY+w3yj0NJ6nqJGs0bYajc6FIvuSo3mQKlaYPayu5HqbjoRUTOv6V9sEKd+g8/2HUC
         Jvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=P1oNGKHauoarsefVawtt6JeTu2BppdpNv8SCIMcY6ik=;
        b=mUGXmx1U0gLKTiHfC0yq+dO2hDgqr+derXE/w5EpD67C7mZ/v+gwihWSaN+cl67DTV
         Io6sEeFszB1aO/Citk61+5YcOumYHMJnXTBt7PkKl7stw4AZDpNemxQgDktS46rQu1aJ
         gZhGqtIhQeqbnE947U7H2nwuZOgmVgvVqokvOvhqg9hL0CtK3Vm/KKLfqfXdcSulZ0Uk
         a3IwE0Yld6T30/ND+puUGfnYDfU17oXCZDCexKJlhJqsioz/whizWnjlTd6R3xqTMKe3
         z3YaoSraMvcCIwygCM2NWU7AMuXBQV2q1xXy2kX3mgFKxb1zoGGF0V4cT53D+uOG1+jZ
         7HPg==
X-Gm-Message-State: ACgBeo3xvb95XFlidFiOaHEF20ZjjuZTa+MUZ1Mmn8tamfuXuoLamhu5
        RnexGa6GsQxLkS2vEOb8u+x9R3c++nyw132kf76Q
X-Google-Smtp-Source: AA6agR4EN53PyGj2Y0TJnSKH0u+nmKcsOE14wcJ/XgtSz0SOXqIoeXDlXdyo5Kocv7PYyJdIZbXyoMtdH/+pgb2yUkg=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr2312647oif.136.1661541023781; Fri, 26
 Aug 2022 12:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com> <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk> <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com> <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk> <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
 <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com> <CAHC9VhS15JEJvV8Pp=bAGj5HpVsLiRRHpRt1yi1h-W0GSQgjKg@mail.gmail.com>
 <537daae0-606c-3db4-59dc-2165cc4d212c@schaufler-ca.com>
In-Reply-To: <537daae0-606c-3db4-59dc-2165cc4d212c@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 15:10:13 -0400
Message-ID: <CAHC9VhRXAVCdGrDt8nSLwuCJdCESSHVgo_T4=j41yB00b7w76w@mail.gmail.com>
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 26, 2022 at 3:04 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/26/2022 11:59 AM, Paul Moore wrote:
> > On Fri, Aug 26, 2022 at 12:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> On 8/26/2022 8:15 AM, Paul Moore wrote:
> >>> On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 8/23/22 6:05 PM, Paul Moore wrote:
> >>>>> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>>> Limit io_uring "cmd" options to files for which the caller has
> >>>>>> Smack read access. There may be cases where the cmd option may
> >>>>>> be closer to a write access than a read, but there is no way
> >>>>>> to make that determination.
> >>>>>>
> >>>>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >>>>>> --
> >>>>>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> >>>>>>  1 file changed, 32 insertions(+)
> >>>>>>
> >>>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >>>>>> index 001831458fa2..bffccdc494cb 100644
> >>>>>> --- a/security/smack/smack_lsm.c
> >>>>>> +++ b/security/smack/smack_lsm.c
> >>>>> ...
> >>>>>
> >>>>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> >>>>>>         return -EPERM;
> >>>>>>  }
> >>>>>>
> >>>>>> +/**
> >>>>>> + * smack_uring_cmd - check on file operations for io_uring
> >>>>>> + * @ioucmd: the command in question
> >>>>>> + *
> >>>>>> + * Make a best guess about whether a io_uring "command" should
> >>>>>> + * be allowed. Use the same logic used for determining if the
> >>>>>> + * file could be opened for read in the absence of better criteria.
> >>>>>> + */
> >>>>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> >>>>>> +{
> >>>>>> +       struct file *file = ioucmd->file;
> >>>>>> +       struct smk_audit_info ad;
> >>>>>> +       struct task_smack *tsp;
> >>>>>> +       struct inode *inode;
> >>>>>> +       int rc;
> >>>>>> +
> >>>>>> +       if (!file)
> >>>>>> +               return -EINVAL;
> >>>>> Perhaps this is a better question for Jens, but ioucmd->file is always
> >>>>> going to be valid when the LSM hook is called, yes?
> >>>> file will always be valid for uring commands, as they are marked as
> >>>> requiring a file. If no valid fd is given for it, it would've been
> >>>> errored early on, before reaching f_op->uring_cmd().
> >>> Hey Casey, where do things stand with this patch?  To be specific, did
> >>> you want me to include this in the lsm/stable-6.0 PR for Linus or are
> >>> you planning to send it separately?  If you want me to send it up, are
> >>> you planning another revision?
> >>>
> >>> There is no right or wrong answer here as far as I'm concerned, I'm
> >>> just trying to make sure we are all on the same page.
> >> I think the whole LSM fix for io_uring looks better the more complete
> >> it is. I don't see the Smack check changing until such time as there's
> >> better information available to make decisions upon. If you send it along
> >> with the rest of the patch set I think we'll have done our best.
> > Okay, will do.  Would you like me to tag the patch with the 'Fixes:'
> > and stable tags, similar to the LSM and SELinux patches?
>
> Yes, I think that's best.

Done and merged to lsm/stable-6.0.  I'm going to let the automated
stuff do it's thing and assuming no problems I'll plan to send it to
Linus on Monday ... sending stuff like this last thing on a Friday is
a little too risky for my tastes.

-- 
paul-moore.com
