Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4F5A3001
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 21:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiHZTcB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHZTcA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 15:32:00 -0400
Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8C6E01DD
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 12:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661542318; bh=eRSaZDAZjSTKQf2yiKPJQIq4Fswa5nLrigar4ETRbo4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Q0HW0R0DdU4j27d3XH9AZijQuJwUmrJUrNgmCxqeYWNGxxCKiLxhv0dUx6niBhK3612jtuHIzAeBb38CIA5FZP7f0QGbb9skYVCrogjoUVRY8mXpozsYH4G23RKHItzamVZQy30UQ6BzbxXeKErwZWkkGonxdj1IKG3IxTAY+m4ta83vcWhJvobnzHSo3i+simUWCM1WbRrJWOl2YvM4wKAWQoh56rR0fv6h18ErLr//94FtQycSTuXm38nm2R4+XxuqwxyeE9Wa7qHvwnZlzU1DuFEg/tUw0pe+Ukkh3GM10rqHbKUK+334lvS+t2gnX5Kt2gPCfT1pnYqpm+8cPw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661542318; bh=yx3VYsjdXgMngqM1wo6/2rm3CGvgCaN8HKtbbikYPrh=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=eAVca3b+RUI24VY8V72Hflca0bMs67ubrRalCpcjIwosBeRcM7789sjps9p+VeWlyUvAY7swPUdRQZHP9gUpvXKmpRHgn9ccOGgqsB3DDewpT4ooHJzHe9je7jrVFqD1a2jGtsQCI3JCqquc6DE2SRCtr0216OzKqUMhdTz3TISiR8ydKTNm/t/jXwAwzfr4zA9sDSWBNflVqLAwgHV1CDE3mj6TfZQxhBykE2rla9Blwad6UiZCYmNFOduYvHvtwEtYnDjZQWkw8YJlblJf14p7lPA5D9C8WJRSKekv1aUiU7jYPcTB4bzGmT7Fnjb9KnLdrGk6SYyqxOUwcdc7fg==
X-YMail-OSG: ihTGedMVM1mDnpmh20pBNxRoYKIDXQ1bfsj9NuvVi.BuTCcDJrgEZQsk76O.rSG
 HrchBmZGZr4OtfsTSfuQxMhUONShlwNDKn6iOYeeFJYz1iFykBdZ9AEJ3j55G0m4c_uBXQveR5Sw
 gyCxbPo5RedC_pt7s5tw.YbLQBtxiIITptUvX7j6QpkFA53aO9yaENN9S6ibIQlOal4fmMXql6Xl
 9Cf.uCw_G.hQuoruoVtVpGLHjIY7PSe0AE.8vYyAH1mGSIVX3d_8kGgfoJHryYRDYQaYZBiSDkw8
 vdfMU0dPAQwGkQiy.yGMjdoIKi.NT_B70D_EVQi2qYn1n69UKrzKwgh7VbZ3Eivs9dkGa5m.LFtj
 b9Vewvokw8Akev.pAF_M.fCXCmbhVLRQ0fBhGE8Awb30ZfXRCJLJdkq36W9P.gWleVQGEJefdkfj
 2AbzOD7bJgrPwgeNKBMHhZ9DWrSv9XRRs1HR78MSv.bC61umJYlZVPURURqFti24DQWGRtD4.qCs
 7wzVGezIdHvpH9PNYbyLLXNrr1oaNUDg9Ji9mGFbsTq9JBSEXOEC7qqEzLpw6m3eakNk48_8TUEa
 QLsmvxl8ErTKAg1U6tz12IQ8uKIjHoS8qBHzKLxKTcZQOVQKPqQN7YWHlhkSpf7cBQoRNdtokY1R
 0vPDBqv4rCkArHPM94syk7R_JkzppfIRWZdu77.n7rirkYyUVLvU3SOPzfKLidC9wjfd5mkSdUqI
 7w86ZfJV_wCeJcX6yhS8uJM96cFXksSXej6tUgDABN_vxSUFl438jrdlg0FN_wZkdD9btPI9sSw9
 MOZeuOfF1USGT47b7tA0DPjFEZJMFdIwXQVVj1C90BKFSJi6zCRTe3VjTOyVFO1UQQcoKbBhfdhT
 .R3cBUM3Uw5jI22LIN5WFPmUsndHimeZTIMRxKTFz37JCm7.i4PJhB4qaLaRk3AkG.KOtOFx0BRa
 MdzMsPTMe0gCr65Ucp6SOU.EuSMspElLnZvk4Ov491slLF9_ftnxM9XiuX5Evos9nWtPepbx.iL6
 QW_GuL50lQfQ3IftvRQNMaBxdCO.sng_r3ic2XGaO6C.pEqNIy0k5V5vJphtbsSSX7.V2ewDLVpb
 tGsUeNr.Fc6HO7z_ufvUeuLewDVMcMITLpDsK_3XIPCaKur4UDt0N3Wq02vXSvtsVUwlVMkF4L3s
 91_NLaF6_Ix8osGQ6D4nx_ecJrMR6m77KfcFbkSujqe24U0jZSxCy_IIbc0_k0HoWge39l9Mv6Bw
 VGQY3zLsaKpJl_Q_KfHTyjAnleg7WC1QGn_1lIY7JyacpzC7YD6d4F03FC_tlFMpuzCVugd6LBjK
 n8slMk2jss4rLMNEW13Rl0moXOwXzV3NwjcIdHDqyU4KVkLmfgZHaiSvl40xECdLrQ8j3NX77kPk
 6Z.rEdIsfKuNEs6cKH82FBi039clk1php.DIKAjIUkaPd41tcze_LMV_8IuKXenJREbdPF_SAobs
 TF4GWh2XBoFDcvXxSPr.IywvP.USVSVoTAQFA7eqx9YFrtwNbM7ygghTYFzbHKTXXVxRTHJbPU5J
 tN8l.pvEJZSTq_b8ohZVkRsrc630_WZU8B0VZOG6mRsYOMxz5IO1A_9RIEKauvKEq75D6a4_evYj
 ShiNXUly7jhsxALQ9GUZCU1FIW232IuB91f_7W.6BGfGNfexna1BZPVVhJxisR9v0zyQme6y7mD1
 1Kpz0Z1MlZYD4rVDFsIwXeFX1cuVPUpneQUT2BrVSoGAbIqto_qrdDNCpNLadS59zPDyKu3BVCZU
 fwEAu7RagpAmrgfipL6G6kkcowHnE1VirxRgOUnQ0FehtM.BJguXYK1zS40WLC1gnM7h0AM5JQgJ
 7jJZhKyjvIdQxNUjo3JN8HQckWfo9QKJuyfqsI.z8_jDYnq4MSw55LlYMVHjjrn89LtEkCVE4h8W
 92wh1TYsriYlqxWseHKc8X4oS2Ejnxhei6ckZ8oXMKP6M.SQ1HW9HyuS7Cq7BM29x6OEIgwcqVh.
 X2m0CYWHj_ZbiI5dY38_lwf9R1KgS4lX3Q07tOr.6nyt3GqyfMaomABdzieMa4C0wtru40L7x4CV
 8fsUYt0bQ0iTkRGP.OCUraSd_vW6qzxfBcTyxVBFoIEVG2sFdJWNO_8s3anBwmNcl63TxMJraB2F
 honZstHMti3JN8S9VZXEaHA7h08TAiFNockwjy1byU8UMAx_jrP1pVYpHKD8GKoGBz.WqIa.7yJ.
 d9vzXfHmRROECm49S9PusGz0O_FKYAWki3mks7w--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Fri, 26 Aug 2022 19:31:58 +0000
Received: by hermes--production-ne1-6649c47445-f6s6h (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f510391c75d9030ef3dc7f2844e75d1c;
          Fri, 26 Aug 2022 19:31:57 +0000 (UTC)
Message-ID: <902a8524-0e36-8515-a380-8b85831e17f7@schaufler-ca.com>
Date:   Fri, 26 Aug 2022 12:31:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com,
        casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
 <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
 <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com>
 <CAHC9VhS15JEJvV8Pp=bAGj5HpVsLiRRHpRt1yi1h-W0GSQgjKg@mail.gmail.com>
 <537daae0-606c-3db4-59dc-2165cc4d212c@schaufler-ca.com>
 <CAHC9VhRXAVCdGrDt8nSLwuCJdCESSHVgo_T4=j41yB00b7w76w@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhRXAVCdGrDt8nSLwuCJdCESSHVgo_T4=j41yB00b7w76w@mail.gmail.com>
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

On 8/26/2022 12:10 PM, Paul Moore wrote:
> On Fri, Aug 26, 2022 at 3:04 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 8/26/2022 11:59 AM, Paul Moore wrote:
>>> On Fri, Aug 26, 2022 at 12:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> On 8/26/2022 8:15 AM, Paul Moore wrote:
>>>>> On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 8/23/22 6:05 PM, Paul Moore wrote:
>>>>>>> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>>>> Limit io_uring "cmd" options to files for which the caller has
>>>>>>>> Smack read access. There may be cases where the cmd option may
>>>>>>>> be closer to a write access than a read, but there is no way
>>>>>>>> to make that determination.
>>>>>>>>
>>>>>>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>>>>>>> --
>>>>>>>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>>>>>>>>  1 file changed, 32 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>>>>>>> index 001831458fa2..bffccdc494cb 100644
>>>>>>>> --- a/security/smack/smack_lsm.c
>>>>>>>> +++ b/security/smack/smack_lsm.c
>>>>>>> ...
>>>>>>>
>>>>>>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>>>>>>>         return -EPERM;
>>>>>>>>  }
>>>>>>>>
>>>>>>>> +/**
>>>>>>>> + * smack_uring_cmd - check on file operations for io_uring
>>>>>>>> + * @ioucmd: the command in question
>>>>>>>> + *
>>>>>>>> + * Make a best guess about whether a io_uring "command" should
>>>>>>>> + * be allowed. Use the same logic used for determining if the
>>>>>>>> + * file could be opened for read in the absence of better criteria.
>>>>>>>> + */
>>>>>>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
>>>>>>>> +{
>>>>>>>> +       struct file *file = ioucmd->file;
>>>>>>>> +       struct smk_audit_info ad;
>>>>>>>> +       struct task_smack *tsp;
>>>>>>>> +       struct inode *inode;
>>>>>>>> +       int rc;
>>>>>>>> +
>>>>>>>> +       if (!file)
>>>>>>>> +               return -EINVAL;
>>>>>>> Perhaps this is a better question for Jens, but ioucmd->file is always
>>>>>>> going to be valid when the LSM hook is called, yes?
>>>>>> file will always be valid for uring commands, as they are marked as
>>>>>> requiring a file. If no valid fd is given for it, it would've been
>>>>>> errored early on, before reaching f_op->uring_cmd().
>>>>> Hey Casey, where do things stand with this patch?  To be specific, did
>>>>> you want me to include this in the lsm/stable-6.0 PR for Linus or are
>>>>> you planning to send it separately?  If you want me to send it up, are
>>>>> you planning another revision?
>>>>>
>>>>> There is no right or wrong answer here as far as I'm concerned, I'm
>>>>> just trying to make sure we are all on the same page.
>>>> I think the whole LSM fix for io_uring looks better the more complete
>>>> it is. I don't see the Smack check changing until such time as there's
>>>> better information available to make decisions upon. If you send it along
>>>> with the rest of the patch set I think we'll have done our best.
>>> Okay, will do.  Would you like me to tag the patch with the 'Fixes:'
>>> and stable tags, similar to the LSM and SELinux patches?
>> Yes, I think that's best.
> Done and merged to lsm/stable-6.0.  I'm going to let the automated
> stuff do it's thing and assuming no problems I'll plan to send it to
> Linus on Monday ... sending stuff like this last thing on a Friday is
> a little too risky for my tastes.

Agreed. Thank you.

