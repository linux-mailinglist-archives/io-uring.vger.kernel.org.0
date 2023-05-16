Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC83C704F19
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 15:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjEPNUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 09:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjEPNT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 09:19:59 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBFA30E8
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 06:19:55 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-645cfeead3cso1915596b3a.1
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 06:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684243194; x=1686835194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H4WKCdbuZXrmowcWv+oxI/osiNdEe2yY+VSOSYJSfVU=;
        b=D73n14xkNZ0zYWAfu+D9/zERZmjsGnclrNclfwbrnYvXdKydCAM6XXUxP2m6AKjw9k
         b7DrpnkxpJ+Z0aRuB3wun0x8dtBoeijqC+32ligWep5AlzcsoQswye5v5kmJhwM0ckEA
         /tspQmFWZkOAij0vir4X0awGwbkH6EYQMvHsyeoW0ReJ0MQRswPBdAOPp34BH79xhbTX
         yOY3DrZlG1QVbDvp0qJJFISARYyqIIZYBZ88Ihs1Nu3fXbLciLK7P4pu6Id6D7XVt6uX
         V0ErAmZ5pTUZ8vWdFAiCssJprIc1xiBwRAzMgywt7JCnYpOr6xyDTxcb9X/ZLpGgsQqb
         G7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684243194; x=1686835194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4WKCdbuZXrmowcWv+oxI/osiNdEe2yY+VSOSYJSfVU=;
        b=gi1zW3VYA8xhe9dLDgQbyqOm4Dg7IIGsBeqBoyy2/NagXJAWhOGsM8pH0u+F3jkddp
         x+Zv28bc+GSK8fZsbYNCzPLJaOopdJSi/fqTYYbrpdykOKeHw1yLF2KHgFKrO41sy9yL
         UBTWF7ApcJlAeEDXKIFFqVbOUg72DnfSqzjwFjNUHXOuNdr8P1EoQRZiF1fjariTJTn8
         QXpr2Wrnr+f0L2L4epGtfvxJwjycqVRUhXZqOcXryk/oF0flbYcolT/2pqTa6e4EdtVk
         s7S0yyWPJhvc6XnVcvVKDUWX9XE8H726WI7KYXCZXBobZau9IYc0B2UrJvVD7VJ1faMm
         WhBg==
X-Gm-Message-State: AC+VfDx4aQ0K7fwfXijBlPFfZvJLNZHeN2nJ7bN40hpU9/ZeaDrmkdHr
        ugWvOrlGvV+WtqnbHTlS2ORnJw==
X-Google-Smtp-Source: ACHHUZ4FYse1kBDXE+ZocqaY+d33zSOzIzotgd2H3IRYi1iikVVpeD2YWCQL0aetJ9/7/2v96SEaHA==
X-Received: by 2002:a05:6a00:2790:b0:644:c382:a380 with SMTP id bd16-20020a056a00279000b00644c382a380mr3134121pfb.0.1684243194518;
        Tue, 16 May 2023 06:19:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a4-20020a62bd04000000b0063d47bfcdd5sm13459476pff.111.2023.05.16.06.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 06:19:53 -0700 (PDT)
Message-ID: <a0e99a59-d304-d26e-c5f8-d8ef1bef64ff@kernel.dk>
Date:   Tue, 16 May 2023 07:19:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 4/6] io_uring: rsrc: delegate VMA file-backed check to
 GUP
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
 <c44effe6-029e-4ccb-ce97-2ca5d5099c05@kernel.dk>
 <40ed22bb-53e3-ddc2-45ca-f0e763f26242@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <40ed22bb-53e3-ddc2-45ca-f0e763f26242@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/23 2:25?AM, David Hildenbrand wrote:
> On 15.05.23 21:55, Jens Axboe wrote:
>> On 5/14/23 3:26?PM, Lorenzo Stoakes wrote:
>>> Now that the GUP explicitly checks FOLL_LONGTERM pin_user_pages() for
>>> broken file-backed mappings in "mm/gup: disallow FOLL_LONGTERM GUP-nonfast
>>> writing to file-backed mappings", there is no need to explicitly check VMAs
>>> for this condition, so simply remove this logic from io_uring altogether.
>>
>> Don't have the prerequisite patch handy (not in mainline yet), but if it
>> just moves the check, then:
>>
>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>>
> 
> Jens, please see my note regarding iouring:
> 
> https://lore.kernel.org/bpf/6e96358e-bcb5-cc36-18c3-ec5153867b9a@redhat.com/
> 
> With this patch, MAP_PRIVATE will work as expected (2), but there will
> be a change in return code handling (1) that we might have to document
> in the man page.

I think documenting that newer kernels will return -EFAULT rather than
-EOPNOTSUPP should be fine. It's not a new failure case, just a
different error value for an already failing case. Should be fine with
just a doc update. Will do that now.

-- 
Jens Axboe

