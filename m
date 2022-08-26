Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8145A2CD2
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbiHZQxV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344476AbiHZQxP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:53:15 -0400
Received: from sonic302-27.consmr.mail.ne1.yahoo.com (sonic302-27.consmr.mail.ne1.yahoo.com [66.163.186.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE55A193C6
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661532793; bh=c89xvT1uL0/4FPkfiarrr4piCZWk1ESQCXyBnJ/ANf0=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=PJIf4RNENXLqUakPnNIATEFFFNcRPNnN055ilC5VF0IBka32tOM2hNMXJWvO6w84Envb8GWA2fGXBjsnZto0dLVNHbH2QsWyq5gLFRH7KJisMqkujkM/twTyWemeLSJ8eoFcXSebhsyyJ/N254e6XCdJwEk9lcRJQ7t+jpBb1yTCDfY7vR4UiIHxHSiYEK3EBqh+k0T3P/+sIoyWZ4Trep2BnK1ypo9MhqeqKRMsBo1fcu8ByHX+GQDcmBAq9Uri6pND9kg/uDsygBUbRzUt0HVke8ks17P+TsahwNwRAhQWKcrEtjiY3F4efUgiGHtnj0pOO49DUiFaYsbaDiQJKg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661532793; bh=j1QFoVrR6EaDgl+1pCSJ7YY3kBIeLz2+MmfvY3sSeL8=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=OnuCjFZgUEMnOMYHkYkfH/e8104fobLRBtoeETjmeuEJSWsZ9XcBubZSrg95H/hkgAZslLN8/yEWS+r4ZI9F108ncgJPoIl/C4gJbE0DT+3xVXz38+htHUyh4ivBddzmqpru1GmNg2saMHW1sLjSH3GqwCfP7OiBPlKuWRLhIdsT5/cCeECnlfBVa6nWfMHq0zJdSLODDBqOscnmXEQL4rpeigELdsNSDIlJD00nZR9bQSva7biaTXtp4ESh+H7eKUTzM5Q2L9JV9HJ07F5I2eA7H6GTT0ese3LCzSNwmbIMe5PoATOkQ9AcLX6TAUznr0DYO+ih6tlWT9ALEvL7ww==
X-YMail-OSG: T_iJYE4VM1mbMA1Mp3PZ.y6iAwS8QA0jgxCc5suw9LvBTTE5FW2EgwO18SznbTY
 HKOTHY_CJpzF.DRZ6q1zBw_zVaNk.1gmoH67TojZl3R9wtR8DtMdeIX7KEi4yD_REtAYqnZj3BYD
 e5emSdXFhceV6lNHtkbnP8Hejp8kKulphnLvFuR62k.5NZ_3oE.pp3Ro.lGv3pEQubZcgOtFI2Lg
 VLg8AI2U.zWdkVYJ_fqgQKenG1HoB6sGM2j1JX93p1CAF31oM4hn4i.18umIyYEADFmAptJ.tGSd
 Zn8hND9rvLkQhXE3R3arGWpAe3gjdR_MV1SyBR.jE2nzhyaQjIQ4HII_gAYaEEXmV._VX06mTg89
 Dr19pe8P2jdHayUnwOq1FG1YII4Wj54nptQFCDJC9COmAoeai0EzE3wGtquTAV_JDSmmF9FEFJ9k
 MOV6PKDrXe37kJ.F10zN1JTLITXosEgnNDz7XvihvOFjF3oxVX_4xKFFt5DtSkhnlO7CXc_hnr4.
 OZnveCH2K7v.UDvxeMvdR4_O6fzjPPFNPoP7udqo_ROddGW6oeXDa6WqFHHQVAawsWTU5PZuIgXU
 y5b0AcfAdGsiY9tAl.BnBIRZR9G5JYvjV3_YAv428G_5_tf0hIqWqEZXyuqebYXkaBEyfCbZ61Hl
 89FSZQgAhrjKoMM1rD1g.AIUYMPDup1hTCJtUKeJFbOwx5Yq.KblTg4gPzcLyunrFet34kxOGosa
 cJ93h1nPpw0dk5zgYEYoAjnwrxKYYZWEqzEjhKUuf9rkRNKQge.1ZfvH9Pfg92ZQcd9Cz_0lEAZW
 wspWE8C9OFyS9PIFyjGeWHudkH41BMwURslRqKzy0wxXTVjX8Ving3D126EbFVCnGWPpy3bpntvB
 oDtiMW90p486fPZPT7JTGkfARA2I7ZjJ0tR119ym9NFs6V_sPR6MGicaF.1YGVApb54IhBP.NGXI
 00b4DQZCRaecMsJJgnYAb.OHSNPTAA82amDGRtRUJ9HSymWDXNoI4T894vlNLt.F250DF2dJ9qtR
 x9zf0SDZrHcjKsFnxSkGyPMi.HbRFgD7KoDgw.LeH1ButdD5w6GpEY1Y08oSCuejPh0mqMjh740q
 cQmvFi11.Ub4P1OeWKb5IIf.ZfF3BjsPfRmbTMMx81FdO5zjkCSUtKiq4xmVkToYiY7_GvJhkVTX
 mAjm6LOaf9lgTCXFjgVCuj8XdOf_1oD5we2ZgYShagx4Z7KtBaYgh8qJua.AIIVenEKjUR9QF5sl
 xi3.08r56wrZy6TQ6CYpvtqByhnGor7FWpCTOdhY5KLCyLLGFR9a.n73TJj7jxpBLWAlRofX8t5j
 VhcoBh55hw55hpx9V9vzKyrxJP4mUeIAas5DRNjdSqQL1uyDg0RTAkaxykIOX6OyIjYIs5qppOSL
 .SLC4ARtol197bT71dsdTbTA3btD1LDx5DiXQliVDrW4DahrCd3iLLGG4Aoxq53EeQsrLrNibtIV
 U6LBnp7rdulYNOpYH3B1YAMK.xyGpex6CYiSZKfvihr_v_OkUBQpcYfptART_TC4Pli.9oHXOWcr
 FvZgCus0c6YO.YOzShf.sA9c4LsYWXq7xdoAgpa.YpNj1MnRX0nJ1s3GtYRhqNTAzXwesnifYJWw
 SYVs4wAyWOAtqF59GNP8zWqjWBJnQ6gytx_7HbjstU0LdlNZqpTwCNwJs_OhY5RCdpKapNtxkcZW
 xy5RPxdD2DFABhySB4KQhCOfPwo43bF65f4Mg.ZSx3v9fmICgaXhmgLcbuNvfUUvtGLmGgQC5XCb
 8hEG8rRhPeveR5H4hk5WJP2UKymc9Oyl89llehf.M6pLcfAqspvpX16wa1n.7GhZC_Xa4ideINX6
 KmHxBSVSjDCVBr0O8Cu8IRdf0imCp69YmL6hQzehgJ1qOVupCUkV7unQO3rSzv0BTF7mFT6Hwsi9
 kaSujNm3q_de._CW.l8LEMFUkluBjXg0rfTwjna84nHyZmS5dg1JH82rTPkDnnPaw7x9FxAcPT8t
 ehtdBcSxc7w9Qmyw9FgnJq6B7xCEM9tDi3uH4Fx.f6DtRlWOOHecBsNZuAUTJGWuiibZpWio0odq
 zCDX2Gcy3oPIL18b0KYd9MexjeQ_Z.5181mxgiqoXJcLTgpSpbkQ77lJ_vHGzLvVrOm6dJQVCG7z
 yCqhXed6d1OvZa6QK.maAefG8wXpigkmuf.zEkqEd1r_7Qz02CsDs8inqxFyXDpxjH.uBMUcnNAr
 v.tfFYEcSi.3.unf9Ce3.FZ9IqMtCIzTP7T96LxWZpl4-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 26 Aug 2022 16:53:13 +0000
Received: by hermes--production-ne1-6649c47445-5hpzl (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4188394d357b6302f4f98842700a749f;
          Fri, 26 Aug 2022 16:53:09 +0000 (UTC)
Message-ID: <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com>
Date:   Fri, 26 Aug 2022 09:53:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org,
        joshi.k@samsung.com, casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
 <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20595 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/26/2022 8:15 AM, Paul Moore wrote:
> On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/23/22 6:05 PM, Paul Moore wrote:
>>> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> Limit io_uring "cmd" options to files for which the caller has
>>>> Smack read access. There may be cases where the cmd option may
>>>> be closer to a write access than a read, but there is no way
>>>> to make that determination.
>>>>
>>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>>> --
>>>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>>>>  1 file changed, 32 insertions(+)
>>>>
>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>>> index 001831458fa2..bffccdc494cb 100644
>>>> --- a/security/smack/smack_lsm.c
>>>> +++ b/security/smack/smack_lsm.c
>>> ...
>>>
>>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>>>         return -EPERM;
>>>>  }
>>>>
>>>> +/**
>>>> + * smack_uring_cmd - check on file operations for io_uring
>>>> + * @ioucmd: the command in question
>>>> + *
>>>> + * Make a best guess about whether a io_uring "command" should
>>>> + * be allowed. Use the same logic used for determining if the
>>>> + * file could be opened for read in the absence of better criteria.
>>>> + */
>>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
>>>> +{
>>>> +       struct file *file = ioucmd->file;
>>>> +       struct smk_audit_info ad;
>>>> +       struct task_smack *tsp;
>>>> +       struct inode *inode;
>>>> +       int rc;
>>>> +
>>>> +       if (!file)
>>>> +               return -EINVAL;
>>> Perhaps this is a better question for Jens, but ioucmd->file is always
>>> going to be valid when the LSM hook is called, yes?
>> file will always be valid for uring commands, as they are marked as
>> requiring a file. If no valid fd is given for it, it would've been
>> errored early on, before reaching f_op->uring_cmd().
> Hey Casey, where do things stand with this patch?  To be specific, did
> you want me to include this in the lsm/stable-6.0 PR for Linus or are
> you planning to send it separately?  If you want me to send it up, are
> you planning another revision?
>
> There is no right or wrong answer here as far as I'm concerned, I'm
> just trying to make sure we are all on the same page.

I think the whole LSM fix for io_uring looks better the more complete
it is. I don't see the Smack check changing until such time as there's
better information available to make decisions upon. If you send it along
with the rest of the patch set I think we'll have done our best.

