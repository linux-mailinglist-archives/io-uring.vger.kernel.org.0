Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33485A2F7E
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 21:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbiHZS75 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 14:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiHZS7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 14:59:55 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC12010F0
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:59:50 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11e86b7379dso1923257fac.10
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4Ust/YdNxZ/D/iMsM1OIdWGsDms7M6rFSN0tbGZCacw=;
        b=JZafyIFyg+OIRhzQJOnobXPAk8LyKy61Uelk3Ni1DL2SPvuBuyP9lsfXXttYkaGdmz
         B0xeqULQlVHzchoMWQjCKsdC7ShFw3Xcet9kxCjZC/v2hV7f++g3VtyXVNweD8Rwe7PB
         vJhhJxpqOiHWIILKx9LKhcxab066+EjPYjDcByw4xi6KL8lo5blcXXrzNkC87aXckujt
         DnSLcgn6lWDy/M0nudaI8iEBls3ULKILjd2HXfzJtZGWXQqWfp2Rsw+pwxKqhtEhqG6l
         SQah4mrNLPshCg5+4yYlV1+jveF9nAqZ5WH6ZIYyyY4q6V0LqABIaEU5qpHdPGxWKEHQ
         dzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4Ust/YdNxZ/D/iMsM1OIdWGsDms7M6rFSN0tbGZCacw=;
        b=WblmP58kqb9lXP4FTtGnVDuQSxLrOOnH02t2kOemux2BnJ72c00v+HMwzWoIS/DbOB
         VpPFleWXDGEORJzKUifCvkveWDFH2aJOovdbqaaGJ/mxEiOJl+eeBpBGtlkpgTYySuGT
         wBNisATSpQxNuvPtENlvuaQ/yVUJIBZSSJ172CBrB97s6JMtXeEJzD7CBNpvPGWMQJit
         OJmlz2sljEqz0t79PTBUqm/7HBMELoG5RrQr0Q8dBEHLgdhmMCToWc24TWFNG23Y/Iff
         VZGzKDaeUDYyeM8xQt4RZ9j8ASBQIm3oWiO0tMGzH84TqiyVcijJSJJ+YYBl3gWXD59n
         0DFg==
X-Gm-Message-State: ACgBeo1OfTYx42AUVxa7qYxii0i1vgYN2f3a4HK3x3tdgwnGqKDkkuaC
        iagTT9VpVDXnPhafgU8qB1ey7a3smdVL2nH8iyCF
X-Google-Smtp-Source: AA6agR54/7mHxaqmLY2pXNqs5l0oEbm6rjGe1bsBBuArwRgPGSXGz3dAJmx85eCO3KVrCPxKq/H8+B6TK321NOnKigc=
X-Received: by 2002:a05:6870:7092:b0:11d:83fe:9193 with SMTP id
 v18-20020a056870709200b0011d83fe9193mr2609525oae.41.1661540390168; Fri, 26
 Aug 2022 11:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com> <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk> <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com> <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk> <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
 <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com>
In-Reply-To: <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 14:59:39 -0400
Message-ID: <CAHC9VhS15JEJvV8Pp=bAGj5HpVsLiRRHpRt1yi1h-W0GSQgjKg@mail.gmail.com>
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

On Fri, Aug 26, 2022 at 12:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/26/2022 8:15 AM, Paul Moore wrote:
> > On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 8/23/22 6:05 PM, Paul Moore wrote:
> >>> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>> Limit io_uring "cmd" options to files for which the caller has
> >>>> Smack read access. There may be cases where the cmd option may
> >>>> be closer to a write access than a read, but there is no way
> >>>> to make that determination.
> >>>>
> >>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >>>> --
> >>>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> >>>>  1 file changed, 32 insertions(+)
> >>>>
> >>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >>>> index 001831458fa2..bffccdc494cb 100644
> >>>> --- a/security/smack/smack_lsm.c
> >>>> +++ b/security/smack/smack_lsm.c
> >>> ...
> >>>
> >>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> >>>>         return -EPERM;
> >>>>  }
> >>>>
> >>>> +/**
> >>>> + * smack_uring_cmd - check on file operations for io_uring
> >>>> + * @ioucmd: the command in question
> >>>> + *
> >>>> + * Make a best guess about whether a io_uring "command" should
> >>>> + * be allowed. Use the same logic used for determining if the
> >>>> + * file could be opened for read in the absence of better criteria.
> >>>> + */
> >>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> >>>> +{
> >>>> +       struct file *file = ioucmd->file;
> >>>> +       struct smk_audit_info ad;
> >>>> +       struct task_smack *tsp;
> >>>> +       struct inode *inode;
> >>>> +       int rc;
> >>>> +
> >>>> +       if (!file)
> >>>> +               return -EINVAL;
> >>> Perhaps this is a better question for Jens, but ioucmd->file is always
> >>> going to be valid when the LSM hook is called, yes?
> >> file will always be valid for uring commands, as they are marked as
> >> requiring a file. If no valid fd is given for it, it would've been
> >> errored early on, before reaching f_op->uring_cmd().
> > Hey Casey, where do things stand with this patch?  To be specific, did
> > you want me to include this in the lsm/stable-6.0 PR for Linus or are
> > you planning to send it separately?  If you want me to send it up, are
> > you planning another revision?
> >
> > There is no right or wrong answer here as far as I'm concerned, I'm
> > just trying to make sure we are all on the same page.
>
> I think the whole LSM fix for io_uring looks better the more complete
> it is. I don't see the Smack check changing until such time as there's
> better information available to make decisions upon. If you send it along
> with the rest of the patch set I think we'll have done our best.

Okay, will do.  Would you like me to tag the patch with the 'Fixes:'
and stable tags, similar to the LSM and SELinux patches?

-- 
paul-moore.com
