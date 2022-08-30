Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458555A660F
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 16:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiH3ORL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 10:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiH3ORK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 10:17:10 -0400
Received: from sonic308-14.consmr.mail.ne1.yahoo.com (sonic308-14.consmr.mail.ne1.yahoo.com [66.163.187.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC33ADCFE
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661869027; bh=CDhk2f5j1pFGYhNaHh45N0fWAsq3nHXhneYpZPA8V/U=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Pxb0xilJHyZY77XFpB8lFithRvztgp4xhjpJnpd073SeA+jS8GmG58wTv6JPJlcD09sKJR9p18hT3O1EqIlC0XkA2XEjzSK82MUbY68N/s50cSBw7AnHkFzEiPc5aGLCfA0rbVoYVRVaKjBJjOGstPadEkzxSnvMQgacLttq7HsZTr5P5rzlEn+6ct//z8M0i4rye+iw3KmYkAZR2NsQvasT967hbvlGoMF2wBwn2DSke560NzhWE58nCUGHs3wZ0GQE6ad+fC1W5j26sCOgSaBDzkA/HOX9qgQE/W9TpH1EcpQniagXRjjppMPyOV6h6gdPrP1L3Fvu0YEfS8eKIQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661869027; bh=lIKtYEbPFFvyCeRfA+RElTBCXRW7qUh/eHXMiCkUReT=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=CfgMme+0Xbj7GPIzuffDPwF2QmG7OHPK1EvNAAKlZFpe6KbPTvw8ZvOvJTXmdXzEPIqosctcSu/nD3UiIv5/3G/4adX2jvIcN6hXRG6aWTKFEh3d+d5RRKUuJjcR0IQPTULRHRB6TAnnTFEqv2IfDppt3OAW0ZfD/QT2YM9sQch5XupPQmRdIRaThxCvL4ItLGzajx+t16uQw4ohMSZ8/QXSO/JCBfUpxc4DacGNnhCwma6SEmcDq8urTLHACVvpkw9wBNgHARc7xse2IbOibWXQuYIgEJnmd38BTZfLQsXk+QE0iHfSCdk0dOjOTVzbIRdHWx3JqLp2RxsdR0heog==
X-YMail-OSG: DwyPSTAVM1murTRJVKNFH7zuQj0CuLBzXqyBGUCVhehQlyH0x6gymV9ctjWBbNU
 OunK9IDo16DMN78C12_nEeJWXnoQN77G5.7DoRuUperQAR4l.zxOhJCHqEU7N6FNonfAIdTgBoy3
 VYKpFvR_n.8BpDB_t43M42.oADCIHZeUSuR0p0oS9Ia3uNhQdhxDbcNq5IeMVIddCwNK6RUlj4hV
 0S5zS764aVGPkKxbH0BhC_pPn2jH4bOgvG.uMTE_xE2wCBTVpRsOVNevgadkMMLY8YK1FqyWPyyk
 6Q_Gvh0snbOnAiYD2cEJHk3jbS.Oz5qe608AIz5c31sCGQ.7XYzWMEhrTf_nWBb5nzRaaCTLTQbT
 Zsrm7ATozm_xaS2Rn9ihprwQCeDOla_mfk2QRq5zPko87nA4g.nbfgH2z9nnTtrI0gyuz9ykLGCE
 Ze12_I4IvkmZJliBsLB9M7lqYww0fFxR7S9PmxJOhHr_Cv6OfEdi1pL6vQQV6rGtwAWsXmlTBwh7
 AAp9vY2Zgr9kxArVsmIqCp21L.1Z0cPrsyaDEw8Z1gbbZOtXQe42O87V0ZrylbS.oUf4u9iWsweJ
 FWyLgc9KW6aaQg.m.55hdD0J3rXEIPCA41xSwM0a2D.mjJAKzL9._nviuLukwS0KmEVeGOsSsdLv
 nHjZ1IGT9zibpX6Kg5mFo7o6.e9aoPzzrgN7V5Y5qmvAG5xRd.ytzJn2P3_UKvWUK4sE7sW6J5eR
 yt11fabOzVde.Ld_1UYoMfMxWBOgUILgxoANHN3PO.qW3JWtIAD3WPWUZeeMZ8nsBiqjrIes7qt6
 KISYVqetj4llBVynUNP86cLIrg3mSyMJsCGR.ern1a9iqFUgrL9N_6l_Uwe5LV43RksoYtbjjDWd
 S.LLOrs2FDMcgSHuYvZu.MyBWNVoW27PT5PcGsXeJxkW2sum54FIa.DsVoMsi5od0SYNBFVyiluN
 aGYx028.2_PbINISwW0XzsojvWNOkAhoVzM5OB5WjO7ySP69PkzFyEbeSdj2MwuN5s1jhyDmAYdt
 Nu4Ia4Dr5wt5Kj72g5SHxSd1cPtATEIs9.TVCWKLf4WCmQ1JG0PNSQ_BZouyFVXNP0p.rLypgEuI
 pMH7jUGBkHhIDfyhdKmMOw18ukZJ7ebWEg9q27Zw5xVrByWtk7NQ6GGq844wSuV9Iux3l2nE99Cy
 82Ut4vXSnvJT19cNZ7ODuMI2Suy5EUY.ElqQS45pmYumbLVb.Q4Mo8FyXqLLSd.cfmt2awrlPwyS
 HCZUmWToOjhcCf5GRwtURuoT1B8xp8f.uRK.zESnUPz3rHiiBvDkAkzV.CA30n2NYQoXvrBpaqKt
 tESohPzR9p.GGt2CzREESJuWHUSu9yxpwF2GXff7BK1CnFyAtMMQwvZXo.O3i1BsnOa.NSziMAWD
 jVxh1L16b3aAhZYVzWjkJ.0VzfVLD1FJ9tzAM17bVqJNOV0Xx8uR.KhBPWAZezwZYkoM_pJ3jLo_
 S3ify_MqfRXGDl6TyORxYJ8KPQ14_3nbM9_hmTEhE6KVpalAucj1KcckuPZrVWn34V2_CUqob6tB
 D4VTPmKLBZPOTkq7ho_UgejHdlxOyQPQKPcMBVdkp9mtOqrM7epG12Zx8kXOc9REumrFlG_pvlDz
 Lo1XdDaPueIFBQ8QUbylyjKlM9ebpdHXzfMmvqliY6OaQIlsHWDbteJNxEvx3MDHbC8tYoQkxecn
 TvwSWcPMVpJLgTUETOeoCPmEmVvtOLXyTpter6FBPW2LxRNA8jRAEhbreTUoiglUrfs7wyado6gH
 owTksdgCYFpq6wnU903mmTqs71DOJ_qxXCABBaagqINYyeK962MLik7AMkoaEAOquNmoavIJXlhL
 iS1PrtOhR27MuuYRen7hf_9T48c5zIedYy9_4mvNHKCqc71w4yK14UGl.z9K9ms3U3tdOaQ0nnAo
 G.OubjHQkCtyirUtEHUMDfZVmkdvMfsWGB8ZUFt4v4T7e_6Y97WVbG7iqc0W57MX68tjdp4sRk6C
 11FA05iyZOrBnI7YdYHLmHnSKqmm2Xk74zVYn.K7H7ps3eNQQLv.X6ImxI9nNCObYpuod75WGD4j
 a.n6ZvSGWElQHXd7RiZKcHQFVPKJg5tdXGsxvDBxp9K_qVsnAVOwMNRGRtY8QXpmcYZ_KBLx3tpo
 YBIf2KenJgaAz4De2HJzVMzQVsIU_.JnEiURkTtcHo.9FQpnZqguGd_R7YgeLLrD8q08YymzeCf.
 j_vYX.9d3_n0jOsA6E5JlRgLkifolPPQoQlhrsSCWHOo-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Tue, 30 Aug 2022 14:17:07 +0000
Received: by hermes--production-bf1-7586675c46-qm5wn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b11d744da5bcee07e92476d3d425fb15;
          Tue, 30 Aug 2022 14:17:00 +0000 (UTC)
Message-ID: <41e3fa1e-647a-8f47-9c2b-046209b07a50@schaufler-ca.com>
Date:   Tue, 30 Aug 2022 07:16:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Joel Granados <j.granados@samsung.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <20220827155954.GA11498@test-zns>
 <a6cb7a3b-8393-c8f3-60f6-00ae08dab23a@schaufler-ca.com>
 <20220830130843.mp5j2e5psrg6js56@localhost>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220830130843.mp5j2e5psrg6js56@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20595 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/30/2022 6:08 AM, Joel Granados wrote:
> Hey Casey
>
> I have tested this patch and I see the smack_uring_cmd prevents access
> to file when smack labels are different. They way I got there was a bit
> convoluted and I'll describe it here so ppl can judge how valid the test
> is.
>
> Tested-by: Joel Granados <j.granados@samsung.com>

Thank you.

>
> I started by reproducing what Kanchan had done by changing the smack
> label from "_" to "Snap". Then I ran the io_uring passthrough test
> included in liburing with an unprivileged user and saw that the
> smack_uring_cmd function was NOT executed because smack prevented an open on
> the device file ("/dev/ng0n1" on my box).
>
> So here I got a bit sneaky and changed the label after the open to the
> device was done. This is how I did it:
> 1. In the io_uring_passthrough.c tests I stopped execution after the
>    device was open and before the actual IO.
> 2. While on hold I changed the label of the device from "_" to "Snap".
>    At this point the device had a "Snap" label and the executable had a
>    "_" label.
> 3. Previous to execution I had placed a printk inside the
>    smack_uring_cmd function. And I also made sure to printk whenever
>    security_uring_command returned because of a security violation.
> 4. I continued execution and saw that both smack_uiring_cmd and
>    io_uring_cmd returned error. Which is what I expected.
>
> I'm still a bit unsure of my setup so if anyone has comments or a way to
> make it better, I would really appreciate feedback.

This is a perfectly rational approach to the test. Another approach
would be to add a Smack access rule:

	echo "_ Snap r" > /sys/fs/smackfs/load2

and label the device before the test begins. Step 2 changes from labeling
the device to removing the access rule:

	echo "_ Snap -" > /sys/fs/smackfs/load2

and you will get the same result. I wouldn't change your test, but I
would probably add another that does it using the rule change.

> Best
>
> Joel
>
> On Mon, Aug 29, 2022 at 09:20:09AM -0700, Casey Schaufler wrote:
>> On 8/27/2022 8:59 AM, Kanchan Joshi wrote:
>>> On Tue, Aug 23, 2022 at 04:46:18PM -0700, Casey Schaufler wrote:
>>>> Limit io_uring "cmd" options to files for which the caller has
>>>> Smack read access. There may be cases where the cmd option may
>>>> be closer to a write access than a read, but there is no way
>>>> to make that determination.
>>>>
>>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>>> -- 
>>>> security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>>>> 1 file changed, 32 insertions(+)
>>>>
>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>>> index 001831458fa2..bffccdc494cb 100644
>>>> --- a/security/smack/smack_lsm.c
>>>> +++ b/security/smack/smack_lsm.c
>>>> @@ -42,6 +42,7 @@
>>>> #include <linux/fs_context.h>
>>>> #include <linux/fs_parser.h>
>>>> #include <linux/watch_queue.h>
>>>> +#include <linux/io_uring.h>
>>>> #include "smack.h"
>>>>
>>>> #define TRANS_TRUE    "TRUE"
>>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>>>     return -EPERM;
>>>> }
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
>>>> +    struct file *file = ioucmd->file;
>>>> +    struct smk_audit_info ad;
>>>> +    struct task_smack *tsp;
>>>> +    struct inode *inode;
>>>> +    int rc;
>>>> +
>>>> +    if (!file)
>>>> +        return -EINVAL;
>>>> +
>>>> +    tsp = smack_cred(file->f_cred);
>>>> +    inode = file_inode(file);
>>>> +
>>>> +    smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
>>>> +    smk_ad_setfield_u_fs_path(&ad, file->f_path);
>>>> +    rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
>>>> +    rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
>>>> +
>>>> +    return rc;
>>>> +}
>>>> +
>>>> #endif /* CONFIG_IO_URING */
>>>>
>>>> struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
>>>> @@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[]
>>>> __lsm_ro_after_init = {
>>>> #ifdef CONFIG_IO_URING
>>>>     LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
>>>>     LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
>>>> +    LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
>>>> #endif
>>> Tried this on nvme device (/dev/ng0n1).
>>> Took a while to come out of noob setup-related issues but I see that
>>> smack is listed (in /sys/kernel/security/lsm), smackfs is present, and
>>> the hook (smack_uring_cmd) gets triggered fine on doing I/O on
>>> /dev/ng0n1.
>>>
>>> I/O goes fine, which seems aligned with the label on /dev/ng0n1 (which
>>> is set to floor).
>>>
>>> $ chsmack -L /dev/ng0n1
>>> /dev/ng0n1 access="_"
>> Setting the Smack on the object that the cmd operates on to
>> something other than "_" would be the correct test. If that
>> is /dev/ng0n1 you could use
>>
>> 	# chsmack -a Snap /dev/ng0n1
>>
>> The unprivileged user won't be able to read /dev/ng0n1 so you
>> won't get as far as testing the cmd interface. I don't know
>> io_uring and nvme well enough to know what other objects may
>> be involved. Noob here, too.
>>
>>> I ran fio (/usr/bin/fio), which also has the same label.
>>> Hope you expect the same outcome.
>>>
>>> Do you run something else to see that things are fine e.g. for
>>> /dev/null, which also has the same label "_".
>>> If yes, I can try the same on nvme side.
>>>
