Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0168E59F015
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 02:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiHXAH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 20:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiHXAH3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 20:07:29 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E776D41D18
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 17:07:27 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x19so12166314pfq.1
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 17:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=g+A6KutNs8+EgrYXKQvP82Oy4lgA05KFbMPmkGVpgYI=;
        b=vyMzwFXK3Az2O1RCPSLomtA3ZyxCOBCtsZdFecqTUtDer7d80LHxSLHj6x9bmH9Sm+
         lFGTMMbQdpEVAuHzEOsTjGVU33a6nxUNd0qblKY71TqsP3h9kKgGPqc7IRqmrymO2u7t
         NIWFMlObJm8okw8LWC8C5ePDylXrKarVKt+4WJiyxmh4OvhfIVThwahkHfqm0daGjp8p
         ttMNriUcAHQ6vVXsRS+1LuCVzDLKMlNRakQPWNv+/vKCSholovHJl0Rfv8qfRI3zti2T
         FtgZVOpyE9UkBXjlypFX9YUppLoYVvekCbWlMDH9Szta9r1rGW6wK5y0oLJGSQaxezUn
         FXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=g+A6KutNs8+EgrYXKQvP82Oy4lgA05KFbMPmkGVpgYI=;
        b=CepmCXJQgpyutJC4vcofQUzUDkZo0u3/4r1c8VvJo+61tn71jf56L4gQkryKH7NFg7
         f90/mFQZ05H3I/YOhUMswyN+Kcme4SBgMMQwAoLasvakPZuvB+Qt9vFsF37BgK0mIy/J
         4u+cGKsacW2Q4CmBQBLCkLNHJT9WKWL1xunjZnhX/eogVqWnS0h4d0N5w0ufGKK9JMc/
         NNQT59XGS+a/c0eu1hME4mLQsuY3Ys/XZPD5a9TcX5aREtDruenAvVqEkGu3wRDKEFql
         7ofufmohGpNI/COYJfT2zjTHa1YyEZdjIOyu8Ec1dxz5TQ2+HdTGa2AqgTC6P42o3wIe
         pmmA==
X-Gm-Message-State: ACgBeo1lpf4okDQOdS4CGzMWteVpsP0Onoyb6Rr30WClmRceDIWWXL1B
        YfM6a1Hi1GYP94+QhscUwNYkjA2cD/yofw==
X-Google-Smtp-Source: AA6agR6qnNGJ0OGH3Fuw+U4rMDsOW/hTjl/p7fGficmg/uea2YfbGXQc0aZpwVryHrvaZm8WVUxjcg==
X-Received: by 2002:a63:4621:0:b0:429:f162:555e with SMTP id t33-20020a634621000000b00429f162555emr21772473pga.63.1661299647375;
        Tue, 23 Aug 2022 17:07:27 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b005367ef405e0sm5823325pfk.85.2022.08.23.17.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 17:07:25 -0700 (PDT)
Message-ID: <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
Date:   Tue, 23 Aug 2022 18:07:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org,
        joshi.k@samsung.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/22 6:05 PM, Paul Moore wrote:
> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>
>> Limit io_uring "cmd" options to files for which the caller has
>> Smack read access. There may be cases where the cmd option may
>> be closer to a write access than a read, but there is no way
>> to make that determination.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> --
>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 001831458fa2..bffccdc494cb 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
> 
> ...
> 
>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>         return -EPERM;
>>  }
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
>> +       struct file *file = ioucmd->file;
>> +       struct smk_audit_info ad;
>> +       struct task_smack *tsp;
>> +       struct inode *inode;
>> +       int rc;
>> +
>> +       if (!file)
>> +               return -EINVAL;
> 
> Perhaps this is a better question for Jens, but ioucmd->file is always
> going to be valid when the LSM hook is called, yes?

file will always be valid for uring commands, as they are marked as
requiring a file. If no valid fd is given for it, it would've been
errored early on, before reaching f_op->uring_cmd().

-- 
Jens Axboe
