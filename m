Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701D5557D69
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiFWN7m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiFWN7l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:59:41 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0D3CA40
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:41 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id 9so10441572ill.5
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VUhWznvZei5+kFH592MCF7QEFhH2VnBumlzkbmidxNE=;
        b=ludxzPNZ3v7smjCoU8SyYDLJhjqYHqCwdK1GCRFOUqyhcSJXBNmvUPUO+rh4pDieEe
         5upsdhNXhL/7NJ++JJeqMG7jW1P4pvXOXjHLDc3aBFKZO2IdJ1lzJa92dpOXC2BsKNsl
         D+GnK7wp0FrJ3fT6IYaFULhfVd4sHLdwDQotW3cdkbWq33XKVdrA0odF+KYWMbT03lgp
         Wxe+Kku8pIpBp3fdFjN5ahJs+zIvf8RSyayLtnbH/MMUhFFAuEo9gnDwEC5/WqhxRbEc
         GHW0nE48dIHph+cLQAgGcccG8eyH1CyOeu16rmbyRwQV1joboUATlEnaxnJAeXKjnJUo
         MQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VUhWznvZei5+kFH592MCF7QEFhH2VnBumlzkbmidxNE=;
        b=3s/YUR9ESKqGbTJhxAkMaRoGBltzs4NS6zqGQJ4FmdUSbqT5+7N2Km0p58AgxKBad1
         pO4Nkm4FCfAiYAoAhWBrVE/aM9tUUkfR3tb640hRTnG7rTkClQkweXr5If5jdJJk12qw
         AzoPJcoYX0Sq0wUvq/UCR0k4O70zHZEDgFnllhRlaPWeIZR7g47M8k9xpbHUuZhe87hW
         gT1FY31m7nnSdoXNEHdpsU9707V+7rYJVFQ8f40YBNKPzvIpN4RSTERuaZQcyhksTVGw
         v/S2eTCXeHxAT/1x6vpohDiCPTFflzxwB+rNyojv6/IqqmEk20EkEE94ecaARKtg6G/s
         PkZQ==
X-Gm-Message-State: AJIora+QYu5oVhidKVSl0NVGSL/lGxcx7GSop2M3I8JyfEpZOxvjfolz
        LPDWdCl9+jfztxWL44143DPeJQ==
X-Google-Smtp-Source: AGRyM1uF3yHgd59PXpVd8Bge9SKPqhNx7qVzn+ottib64PHNRP6CtHJY9Mtp5JFYZpoxCvSi9oFsTQ==
X-Received: by 2002:a05:6e02:214e:b0:2d3:df8c:611 with SMTP id d14-20020a056e02214e00b002d3df8c0611mr4951469ilv.295.1655992780536;
        Thu, 23 Jun 2022 06:59:40 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h14-20020a056602130e00b0065a47e16f53sm10640755iov.37.2022.06.23.06.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 06:59:40 -0700 (PDT)
Message-ID: <42a5e2a0-1298-79e0-1a6c-f251eb431088@kernel.dk>
Date:   Thu, 23 Jun 2022 07:59:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next] io_uring: fix documentation
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <20220623082154.2438260-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220623082154.2438260-1-dylany@fb.com>
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

On 6/23/22 2:21 AM, Dylan Yudaken wrote:
> The doc strings were incorrect, fix these up
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: c0808632a83a ("io_uring: introduce llist helpers")
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
> 
> Hi,
> 
> You may want to just fold this into the original commit.

Yeah, I'm going to fold that in with the -rc4 rebase.

-- 
Jens Axboe

