Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD76B9C0E
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCNQs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 12:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCNQs2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 12:48:28 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444D65DCBE
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 09:48:26 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b5so6685248iow.0
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 09:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678812505; x=1681404505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRCCNgT6mDknip32bvmWUWGEG4KETFKEmttZaBdi8MM=;
        b=LOz7NxUwKuACzrD2UXTSI8Mzf5QqdSfHNMdwwSLOSzlC9IA9PtDjKjeu2jKfd78rot
         o/H6ZLTH0Nln2ah+mphMnNsNavYccAvh99KvwoTXg1+cWVtvasdDvngXIfZ4TX8j4PX2
         P+NDwSDsssRMsUFynbewyf8U4JSaGXUO+AiJwGQEP1+gFtszFc6vYaWtjknUAwW3mcPC
         qXtReGZl5/0TbuPsG1QBlgC1qJrWSN9nsaWWYBqLsxVdMGNCkCAhKA5n7kkNGfj3crFt
         AA1jA+qfy8kZEbgGDWgBOyt+8+F4P/trUuSxbKD7QqJL9pPiax0M1/9URLM5OGFguFhQ
         C9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678812505; x=1681404505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRCCNgT6mDknip32bvmWUWGEG4KETFKEmttZaBdi8MM=;
        b=1Q3k0nrGKoUCCh3oohHbx/76dipZj+bGLJw7zj0tl5Tet3CcxMYJcF5b/HzLFU/SEZ
         0Lww5PEC4bRuDuOEIqFIVXbgZpmIc7IHAXUFhaUL6lYZANs1NvauD1bf2jRo0pZ+C8xf
         TwpSS8HQActKA2fxiieRgb/SNGSQ1otINqFB24AJ+KLG/ivjz+xlahi/26A1vLNvmmge
         phLUoeeVAbvgO0AJWHupogOn9H8SCMFXA9nf9R/HW373Sj0DLDQeEtz+n5wJkOlc9TB5
         R4J+OVvJLVYoKAKG5JfZF8vmbchR4e+WCHk7ecArLNyKuzid7T0KC5/ndG44ie7PpG6q
         f4Og==
X-Gm-Message-State: AO0yUKXNaMHAN3E2Gv4Ilgbq/BOlxmamqD4dRcT9WQmCmsmbNFfLmNSi
        qEil2Gwg7sCPCTokX5Ybh1t66A==
X-Google-Smtp-Source: AK7set9beToQbxS4aa5XSB2OKLCl8bhYD4qyx4NXePLR1Y2TaRa6Z8AiObpi0dpOlThyy93mlZ/6LA==
X-Received: by 2002:a6b:5d10:0:b0:752:dcbc:9f12 with SMTP id r16-20020a6b5d10000000b00752dcbc9f12mr809375iob.2.1678812505480;
        Tue, 14 Mar 2023 09:48:25 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z12-20020a056638000c00b003a2d93487easm911483jao.38.2023.03.14.09.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:48:25 -0700 (PDT)
Message-ID: <bd6e61c2-dd84-d2b1-9f8c-45965e4e9b9d@kernel.dk>
Date:   Tue, 14 Mar 2023 10:48:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Daniel Dao <dqminh@cloudflare.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
 <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
 <20230314162559.pnyxdllzgw7jozgx@blackpad>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230314162559.pnyxdllzgw7jozgx@blackpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/14/23 10:25 AM, Michal Koutný wrote:
> Hello.
> 
> On Tue, Mar 14, 2023 at 10:07:40AM +0000, Daniel Dao <dqminh@cloudflare.com> wrote:
>> IMO this violated the principle of cpuset and can be confusing for end users.
>> I think I prefer Waiman's suggestion of allowing an implicit move to cpuset
>> when enabling cpuset with subtree_control but not explicit moves such as when
>> setting cpuset.cpus or writing the pids into cgroup.procs. It's easier to reason
>> about and make the failure mode more explicit.
>>
>> What do you think ?
> 
> I think cpuset should top IO worker's affinity (like sched_setaffinity(2)).
> Thus:
> - modifying cpuset.cpus	                update task's affinity, for sure
> - implicit migration (enabling cpuset)  update task's affinity, effective nop
> - explicit migration (meh)              update task's affinity, ¯\_(ツ)_/¯
> 
> My understanding of PF_NO_SETAFFINITY is that's for kernel threads that
> do work that's functionally needed on a given CPU and thus they cannot
> be migrated [1]. As said previously for io_uring workers, affinity is
> for performance only.
> 
> Hence, I'd also suggest on top of 01e68ce08a30 ("io_uring/io-wq: stop
> setting PF_NO_SETAFFINITY on io-wq workers"):
> 
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
>                 set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>         else
>                 set_cpus_allowed_ptr(current, cpu_online_mask);
> -       current->flags |= PF_NO_SETAFFINITY;
> 
>         mutex_lock(&sqd->lock);
>         while (1) {

Ah yes, let's get that done as well in the same release. Do you want
to send a patch for this?

-- 
Jens Axboe


