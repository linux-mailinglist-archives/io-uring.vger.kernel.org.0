Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF975A517B
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiH2QUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiH2QUU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 12:20:20 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com (sonic308-15.consmr.mail.ne1.yahoo.com [66.163.187.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DBF140B4
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661790014; bh=PybU+ytLV0C6ZeH0i6pK8fukauBRPu9NcJfNp8IpvZw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=ZYrx9DzaaG/mf9pZJe7rWr9zMhbTztrQ4XFTUbA5Jk2FJ+xj+BJYC+QyrI9awkorX4rf+vAGKSWzsI2YgHwdyypf7Z4m+4bin1IAdiXk/jWh232YStPuTLlOYNyB9HFBe3MYwMFT4gv3oTMZV7tiGB27yszNvnfL9xZgUVNoBq8gy/sjPzCK0ecfjlNLQ4WPORybrEManM4v9wrgOhboUjRDh/DPRuCn03Ynu2e6ocSR6/RyM4ZiyeIe5/5sh+fq7qzAWknNCOB6BXItx4t3+qZ08DQR/Nm2/iYfBKrG9taDL0W2dwnc7nKvUiEEOW7GdOoAXfSoNeXCR78LZ8f7PA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661790014; bh=fIPfnK+ql75c65Wcxpo6l+VnytdrpkKkjuGh+Ho5jXq=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=I2EzbLjXCUEOWXgu0Vxbm1AcLPdY1q5DGxSzQeQeyesMPnGw/U1/eJVaFuE4DxrAYKShvRsezw6B5aQ3ot3srOvpTiXl1ZDEG3NFKfy2P5seKYOcM0e4Aem79f7FaHQbCueVaYZ9IymRn0Kn4tGznYwL3tHa4S+UbOoflob/RLXAFCLcihbfwMDyeTtrj/82jrC3KBdxYusSXmUH7LwLRU8G1Pop/TGc80y+6etht35fVtvCyck+t/8vxSt6vTJZlkdPtCk4kqpU2XumXVgA8Riy5AxoyiPi+b09TXZN7LuaKJFSpMEGJBfyJ8NNIPMXHpZ8kIGT5X+0cUpItuFhvQ==
X-YMail-OSG: WOIzU20VM1mqMBx8sbV5pNohbFiccCaU8BRS2DRu1zt2tK8SQIJD9bTC2uy_IYH
 vXhvV553CGTSp2qgaDrHdfQ0IsS.gZvh4rApZC82tUh8Cyr3pu7pv2unT1Ao9aTYlLHlFd8ZdcB0
 h9OFR_Jdhid1owMTiWz_d13FEFUNSTNuuHXPIsm1HnxN4bueEWEkqCy3fpqgE5.QpN95k6YJLQmE
 yUn5l4FXsiwHO3iUTg61AGCBXFLCXV5qqs6LsNA.Khm8ytT.xbFideu8BNv6uWneUkTd5cfsQzi4
 O6cPtLW8aIg0c4nLslS5GLHGler0WdzTWDhgcYxMp3Ot40JFawDmvJXA4YCQL4YW4MNsSeWASpU4
 B.1wX3wY787EV0coLuuRMLaADnJu8fqZwLxlcIP8e6e7t7RPRnp2c_pETdSsA3DX4LTedQ7Du_T7
 3Cnj8SdXkRsMxHZf5NYP.dIfrUXBucQkjjjVQ6X6Q0hOX1iJ5xTFPpE83iH9XpTMxrn4YVnTHaAL
 kuXTnCZOEOfM6YvjXy7XWo7v9fOdlcvedI_Jb.a40YniDZVHdzBIPrn.aMY0k6ErHTmHHIPoZP2g
 lmyZyIW8Gd3EXZgkQV.VZ0gmIb_VSnY3ZC3syRQhEh5Q5wCS8ZUw6kizpcFNA0c7LOtV9IXdTvYg
 018exnMGGjX7KOcUPnjJcbY0IPFd7T4iIyq3XU.g4uNg6358LAIAaUS2_WZf8jl7W2mq8Hag6AwN
 zuxTJ2spu2BLRMv83NQX1Cc78w9jDwAkNv0y4NTpqSPU1hCHrmh89jlOJKH8gBHv7SaSN7UVB02D
 8et_QeFAx.JKNyh081FizxQz0fpsRjY6QGWamMEcK8dVF_hYUgcXFtTCtryqKEayzUQrYzHV12tZ
 Ja2yISTHkABJMe8.ZaDlRluyVLyPHXhP8QweYTIM9qwFDSgXTYlxEaDh03lUh2TInU6EHhIuKDe1
 xNMERW9cRui6TmO1vyF8NecKzHVKrWYYkkk3F8uUyqdF8Y8lOwTEjGy6lIe9beLB9_tbp4ryNBSY
 KOLOK7JjbkJUt4TWDjt.ISL2BokWoS5D7RXYQOCFsHZ4_KZ3AW5KS1nOkgddVeR5FmGAhTC5NzSd
 CRU2IE3R3PcUNumvoUv9wwqWC1w7fWSY4fPpJew6g.IrjSU4BFWKZSkyXhTk.Cst1WGJvQ6SdBD1
 6m5RBO5eAfeSQyXkH_T6YREoSjcwYmC27eXdbP6Rs1hwXM7Y753tGi0g.k7p197ty3tDwwfnDF6K
 FtbnNwLY8c18pworGmB0aCwIFcOu4N2ERlS.fjt3SAIflBV2F1CWhz.Y.06_nVLH7CmnUHx.zRKs
 TpefquKBGBv6GuJw73quZPu9CVEdkQ7U0.vr2RfvN6RrLXEdj3Nhre_iL8njyc.HU4mTBYGDqXQB
 UBqbvTGWX2YwxJ0yFrNpt98bwPs8hGQF35zfSI6CoVMRQVbBJ5RzT6MkQE07s0hrxOIp0UyhlcER
 CW2oFDi36HuxwaULS5gI2x5vr_hLOkl1YfLmIT5IsDUyjERVGDsxYMy2lIPDrW12KIiY99Efi.20
 NabfH4QWimPoXkFbTi8RvFDxmNzPLX54.66vv20SMrWH16fepa6226rXSeB1kTTWtU4MGfPMMZef
 d4yTqJ7Y0is4gRXpPElzsXwMFw6sw5ohFZbEmD7k4jAnu.Tsf0VqiSfjcuvJvSeWncOlIqnfPtXa
 TyD.b1aKuIEAC7bqCUkd71GvUemZuiMb.dkylFgUcatbzfWMQHkEHMhE9hsOI6c8fM8NzVkmoJB0
 7l4iALvxLZoGH7MvcHUvsob9_tIFPfKMptlUFsfV465F72_YS_Il0iGP6Ph6izv4My9UTcTDxk.C
 sqocxqJUs2TXI5FBULcTQlWN_FfTRqRPs1B3Jg5qP6g9__Y0GdhLl.kpN.Ds_EnUGQL0_jxvL1JO
 caJx5A0JwF7bUYH3mVXYQTVJIegXK5IovbYwCYEbXKCgDaPxK0K1u8AY9o50x599WWqO0CiVPERp
 jwDPQmvjqJbGb7WSkfS6SKOpsqG_B1lO4.Tz7381nMPxJfwdxZ.zeW7NP0kJnY74MGk5g.Ww8HXB
 Ya_26VI5H59LaJwWDbfZBF_Pdvo_2og9MmZjAypfKud5gs9ZvBydUdX29qmDZoqTZRwbrJpQVI7f
 8HkywM1pbTaLp6SYAOIImzYQsXGLu3vHS7CpQEUH3EYWrTh567o7QyUlwWyqfJ69Ljs479UAFR5E
 P63PFnKfbN3GuEfYcnNg_FEHp1igBQkWwPe4qQA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 29 Aug 2022 16:20:14 +0000
Received: by hermes--production-ne1-6649c47445-zmkqs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 8d3478d8bab775260c0de413b0ae1754;
          Mon, 29 Aug 2022 16:20:11 +0000 (UTC)
Message-ID: <a6cb7a3b-8393-c8f3-60f6-00ae08dab23a@schaufler-ca.com>
Date:   Mon, 29 Aug 2022 09:20:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <20220827155954.GA11498@test-zns>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220827155954.GA11498@test-zns>
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

On 8/27/2022 8:59 AM, Kanchan Joshi wrote:
> On Tue, Aug 23, 2022 at 04:46:18PM -0700, Casey Schaufler wrote:
>> Limit io_uring "cmd" options to files for which the caller has
>> Smack read access. There may be cases where the cmd option may
>> be closer to a write access than a read, but there is no way
>> to make that determination.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> -- 
>> security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>> 1 file changed, 32 insertions(+)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 001831458fa2..bffccdc494cb 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -42,6 +42,7 @@
>> #include <linux/fs_context.h>
>> #include <linux/fs_parser.h>
>> #include <linux/watch_queue.h>
>> +#include <linux/io_uring.h>
>> #include "smack.h"
>>
>> #define TRANS_TRUE    "TRUE"
>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>     return -EPERM;
>> }
>>
>> +/**
>> + * smack_uring_cmd - check on file operations for io_uring
>> + * @ioucmd: the command in question
>> + *
>> + * Make a best guess about whether a io_uring "command" should
>> + * be allowed. Use the same logic used for determining if the
>> + * file could be opened for read in the absence of better criteria.
>> + */
>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
>> +{
>> +    struct file *file = ioucmd->file;
>> +    struct smk_audit_info ad;
>> +    struct task_smack *tsp;
>> +    struct inode *inode;
>> +    int rc;
>> +
>> +    if (!file)
>> +        return -EINVAL;
>> +
>> +    tsp = smack_cred(file->f_cred);
>> +    inode = file_inode(file);
>> +
>> +    smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
>> +    smk_ad_setfield_u_fs_path(&ad, file->f_path);
>> +    rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
>> +    rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
>> +
>> +    return rc;
>> +}
>> +
>> #endif /* CONFIG_IO_URING */
>>
>> struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
>> @@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[]
>> __lsm_ro_after_init = {
>> #ifdef CONFIG_IO_URING
>>     LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
>>     LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
>> +    LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
>> #endif
>
> Tried this on nvme device (/dev/ng0n1).
> Took a while to come out of noob setup-related issues but I see that
> smack is listed (in /sys/kernel/security/lsm), smackfs is present, and
> the hook (smack_uring_cmd) gets triggered fine on doing I/O on
> /dev/ng0n1.
>
> I/O goes fine, which seems aligned with the label on /dev/ng0n1 (which
> is set to floor).
>
> $ chsmack -L /dev/ng0n1
> /dev/ng0n1 access="_"

Setting the Smack on the object that the cmd operates on to
something other than "_" would be the correct test. If that
is /dev/ng0n1 you could use

	# chsmack -a Snap /dev/ng0n1

The unprivileged user won't be able to read /dev/ng0n1 so you
won't get as far as testing the cmd interface. I don't know
io_uring and nvme well enough to know what other objects may
be involved. Noob here, too.

>
> I ran fio (/usr/bin/fio), which also has the same label.
> Hope you expect the same outcome.
>
> Do you run something else to see that things are fine e.g. for
> /dev/null, which also has the same label "_".
> If yes, I can try the same on nvme side.
>
