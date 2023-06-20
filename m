Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495D1736CBD
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjFTNGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjFTNGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:06:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD98185
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:06:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-656bc570a05so1263449b3a.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687266395; x=1689858395;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pYEZpn7/FaPOCPG4Vetku3vusb3TY1HyB2K4GeSSnmQ=;
        b=ROj/gKLzQdUHeFVh/oi0spsPkMYhx4/MGxkIO5U41hpyDD4wRmQZLt4RIhiYmqRRsf
         jrHNhTHJLyKBsHWrd+kpTPKWAtorChfmc9feHeMpNNTNB+1YqbjmQsAxP4Iv499ok9hO
         tYOp+eFqy6n1p0zlI0/tbQQ+fFiApae5hNCr+2HvHHuNe8Ee9HsjNpikjkhqdjfBhaiB
         vipb0fbrBSGv4NZQmyVqYkbG9G/iOEnnucJ3SZSZ+etOYbFPVSJ8VDyHVMjTRSwnvQyd
         9ouOXDZqPQNKcsgzrzNzU8cGhyCrqnKkObKzZ/QRfTCWofHXL8AYy+KGixGsrSybe34D
         Dz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687266395; x=1689858395;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pYEZpn7/FaPOCPG4Vetku3vusb3TY1HyB2K4GeSSnmQ=;
        b=F1m32jqtL3SOtsGX9fBop0w5rdfi40AsLE/4Um3KI1LXTAOCbm98zrSkLYe+gStcrY
         CzU6lPO0C+2lYhhMyDrTLsvsw5BHMoSYWeLOc0Tk0wuPyUZXDlYzCvCwsHT55pwiPinu
         nVRk0EFEk/q5dJ+quj6ogvd7Ol5+K6IHn/MUfsyvpT8lcTV6h8CudX2pfiRdVF9mZKwg
         q2BPATC1GlhFNiHvTHTiCTqxHwLqYN0hxw4tTxUnYXkgmSIJNSbdrgUS18Z51qDFRxAI
         m2L05WFyZkZE4mGkQW8k2T9J8mSNHLAVbNCIAF+ayLrJUoN+m8+eVGg8CjyLcbzcb7S+
         ZkAQ==
X-Gm-Message-State: AC+VfDwKgNCErnU50IN2PAavZMTcNiU8+SK/DcfYkc03xshZOcYNwsTS
        pTge307inWSqBJyaehLL+K2BI/iORsgsijvnhWw=
X-Google-Smtp-Source: ACHHUZ5UYxGRAQh5o+yRSYa2SHvgMg3igJwlzgZ10mPwy6iD0EcnTJQI+YteHVjFAfMczDHnPAlb3g==
X-Received: by 2002:a05:6a20:430c:b0:10b:e7d2:9066 with SMTP id h12-20020a056a20430c00b0010be7d29066mr15932798pzk.2.1687266394716;
        Tue, 20 Jun 2023 06:06:34 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g37-20020a635665000000b00543b4433aa9sm1380710pgm.36.2023.06.20.06.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:06:34 -0700 (PDT)
Message-ID: <52bf5316-6a50-8581-266e-1cb8d5b73178@kernel.dk>
Date:   Tue, 20 Jun 2023 07:06:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: clear msg_controllen on partial sendmsg
 retry
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <0fd9ed30-c542-fc18-cc4c-140890da5db4@kernel.dk>
 <1c63c371-b5cd-b6ec-33eb-2e0c61cc59ea@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1c63c371-b5cd-b6ec-33eb-2e0c61cc59ea@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/23 1:56?AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> If we have cmsg attached AND we transferred partial data at least, clear
>> msg_controllen on retry so we don't attempt to send that again.
>>
>> Cc: stable@vger.kernel.org # 5.10+
>> Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
>> Reported-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 51b0f7fbb4f5..fe1c478c7dec 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -326,6 +326,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>           if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>>               return io_setup_async_msg(req, kmsg, issue_flags);
>>           if (ret > 0 && io_net_retry(sock, flags)) {
>> +            kmsg->msg.msg_controllen = 0;
>>               sr->done_io += ret;
>>               req->flags |= REQ_F_PARTIAL_IO;
>>               return io_setup_async_msg(req, kmsg, issue_flags);
>>
> 
> Should we also set 'kmsg->msg.msg_control' to NULL?

We could, but I don't think it matters as we gate any checks on that
anyway. But in terms of completeness, may as well I suppose.

-- 
Jens Axboe

