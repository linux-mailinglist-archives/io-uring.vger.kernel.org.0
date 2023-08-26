Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A72789940
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 23:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjHZVhk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Aug 2023 17:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjHZVhX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Aug 2023 17:37:23 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE63CD5
        for <io-uring@vger.kernel.org>; Sat, 26 Aug 2023 14:37:21 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1c0fa9dd74fso1398728fac.3
        for <io-uring@vger.kernel.org>; Sat, 26 Aug 2023 14:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693085840; x=1693690640;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGFnO3OececeeVrrCE0xAvzwqJCgL0fUnG1B7r4w2nU=;
        b=y2CCnMflJrEiPZ5WyiiCRV6ORzQ3JOHssKQfzhCDt6bPqUc1Ng2sj8y43/N8O3saDB
         RKWV7C7B3q612847FMLn8ROfAvhE0A01r94p/dfPkeVUFvUkMumVr9NqydqJw9ofGYrJ
         w04Tm3/bsngZERhbdeyDCWKxXTg84MpNP/9X19A5qxXyvIJaz5v6gHuesXv3dNlbXAu1
         qXk/jnFsD97lCMWroUrWLDRw7/cKKlX12Y2jJ6F8Rd30HNv7YmK0hF8SVZjWfE9hze5d
         T4oUsXRQKPURB6fIyzTzc9+gaAgEoO+xnSBaKCqPE+cYA28WBUQZzSZbilnYYyjfQtJi
         GrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693085840; x=1693690640;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zGFnO3OececeeVrrCE0xAvzwqJCgL0fUnG1B7r4w2nU=;
        b=NlXicG2nTyb9kpecaBxJRhDAcsqy6fcBPbZ6cIHrF+cv5mzw1jHO7c1E7PRU8foELc
         Pm+8iVILIT5D6cDv7tPV5IZcm6j9SQGHMI1X3u4KI0v04fMf2RkvKldxCtvz1Rp8lZX3
         sHos2xYl8wFPMDZNcUqdORjPwfizqyRyl9D1/aoSbe/0aJNq94G69X88tRE8ZIOMAxk0
         m6k2SO4RvsXm1aXFBwPImQLsoVJLIyps5ihxyxHv1uVN1zokx4AmdRiixRWWpn9fIKdi
         hfvb4Icgp6KQiWzz3FCMZ7nQ3m7RTxJm2IuFtnnd1+y/eJ/u1ljO2QIN+CcY2hoxA9uj
         i/wQ==
X-Gm-Message-State: AOJu0YySlehct9Ekc+C4qrflULZfGVmvJU7bQwlUddRB/GexnZytqq8j
        5ySuzOUCj6Tx5jNHXpgONCtkLQ==
X-Google-Smtp-Source: AGHT+IHNbU7OTg20ri0lktoBFHTDeGMSQFDGRVoz3jAmWaGFZVEFNv5xFqxSp9inwnBBOVrdKOETtw==
X-Received: by 2002:a05:6871:413:b0:1a3:2447:7f4a with SMTP id d19-20020a056871041300b001a324477f4amr6813550oag.32.1693085840573;
        Sat, 26 Aug 2023 14:37:20 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c8::176d? ([2620:10d:c090:400::5:17f])
        by smtp.gmail.com with ESMTPSA id x5-20020a17090abc8500b00268b439a0cbsm3882917pjr.23.2023.08.26.14.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Aug 2023 14:37:20 -0700 (PDT)
Message-ID: <2a6f414b-a6cf-dd33-fb70-9dd36e93841e@davidwei.uk>
Date:   Sat, 26 Aug 2023 14:37:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 03/11] netdev: add XDP_SETUP_ZC_RX command
To:     David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230826011954.1801099-1-dw@davidwei.uk>
 <20230826011954.1801099-4-dw@davidwei.uk>
 <ac2d595a-c803-b512-84c9-a5ab35615637@kernel.org>
From:   David Wei <dw@davidwei.uk>
In-Reply-To: <ac2d595a-c803-b512-84c9-a5ab35615637@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/08/2023 19:21, David Ahern wrote:
> On 8/25/23 6:19 PM, David Wei wrote:
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 08fbd4622ccf..a20a5c847916 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1000,6 +1000,7 @@ enum bpf_netdev_command {
>>  	BPF_OFFLOAD_MAP_ALLOC,
>>  	BPF_OFFLOAD_MAP_FREE,
>>  	XDP_SETUP_XSK_POOL,
>> +	XDP_SETUP_ZC_RX,
> 
> Why XDP in the name? Packets go from nic to driver to stack to io_uring,
> no? That is not XDP.

This new bpf_netdev_command XDP_SETUP_ZC_RX mirrors XDP_SETUP_XSK_POOL above,
both in terms of naming and purpose (the arg structs are almost identical).

However, I dislike this way of toggling ZC RX support anyway and am happy to
change it to a better method e.g. properly supports namespaces.

> 
> 
>>  };
>>  
>>  struct bpf_prog_offload_ops;
>> @@ -1038,6 +1039,11 @@ struct netdev_bpf {
>>  			struct xsk_buff_pool *pool;
>>  			u16 queue_id;
>>  		} xsk;
>> +		/* XDP_SETUP_ZC_RX */
>> +		struct {
>> +			struct io_zc_rx_ifq *ifq;
>> +			u16 queue_id;
>> +		} zc_rx;
>>  	};
>>  };
>>  
> 
