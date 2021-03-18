Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7853405FF
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 13:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCRMrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 08:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCRMrH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 08:47:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7C7C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 05:47:05 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o16so5409017wrn.0
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 05:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/7hhXouXLzXJnQVgooQWsG4lzJE+kCYvy66qhcwIVc0=;
        b=iQ/px8vy+bSVHo9K315/Wv1T2UOq5ZuSDW6/62XqoMfFMT819TPq8ReU8DlSmev09f
         b/drhiFwBNPkjqqNnjFZe6tK0NXLkAR/pZdwkPayplkXv8ugi84lfZUR/41NbQOY+02C
         q3rqTT1sP21innGIpX7P2EBzIoul2Nf2ryGHMBUqpIzsNWzenOX6FucWI06psrKYCvtA
         euHRQ2lsXeZrg98X1pEEsHX2TfT4bUo4MuiCDfPrr/NIFMkTipulmDpcEFF7AVf0zSRJ
         gsgNA6rU8RYfwt1HQZbCOFLmdlE7OUbEuvV+40Db6APtl27UkZWZAafR/tcl6nR2nd4U
         pogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/7hhXouXLzXJnQVgooQWsG4lzJE+kCYvy66qhcwIVc0=;
        b=YIRymc12v6jXVyYq9THhvwzMwD7jhqHwmeMu59WhxAG3QQLeysZZStjbU7Ts1F5sP3
         1k9TNWFTguY6WZvBj8EFJJR+59LXixBw24rg2o7mr9LHaRf0odQHEALpzWSBMREBsXnu
         cJy15AFZD+XArqo148Z2SBzDjAX6M1fNvq7f4SiSEd474zzWnRmw6P1GQuPg1ZjK9Sb/
         mb6XSsRg1JrYqDlwfCedRQdE8VCWOvXhl3N/4qGGj5wmVfyd52e1oOaT046Kxmqv0Xzn
         KfTB1T7z7tgZX5i9jVLRWJiDudgWNLqJakIydpEKzvNlujE5F8QLyGr07s3N1k9WZ5hy
         ZpQQ==
X-Gm-Message-State: AOAM532z3X/DmzSA9Uyt9Lmpxa1/fk5+/wXJul0muUAqbCz6f6raF2A3
        43xnKwLMX+FtbKMrWVGIo2E=
X-Google-Smtp-Source: ABdhPJwBSC/VqhemD3bDjaOq855R5P/g+LLsw2Yki9qlIYVytFpeqhLYhqc0wlhqe4u3hVbjYYC4Ng==
X-Received: by 2002:adf:e809:: with SMTP id o9mr9783503wrm.110.1616071624504;
        Thu, 18 Mar 2021 05:47:04 -0700 (PDT)
Received: from [192.168.8.170] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id g11sm2789419wrw.89.2021.03.18.05.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 05:47:03 -0700 (PDT)
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-7-axboe@kernel.dk> <20210318054506.GE28063@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Subject: Re: [PATCH 6/8] block: add example ioctl
Message-ID: <dc15ec75-46c3-8e24-d061-5992f7dedcd1@gmail.com>
Date:   Thu, 18 Mar 2021 12:43:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210318054506.GE28063@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/03/2021 05:45, Christoph Hellwig wrote:
> On Wed, Mar 17, 2021 at 04:10:25PM -0600, Jens Axboe wrote:
>> +static int blkdev_uring_ioctl(struct block_device *bdev,
>> +			      struct io_uring_cmd *cmd)
>> +{
>> +	struct block_uring_cmd *bcmd = (struct block_uring_cmd *) &cmd->pdu;
>> +
>> +	switch (bcmd->ioctl_cmd) {
>> +	case BLKBSZGET:
>> +		return block_size(bdev);
>> +	default:
>> +		return -ENOTTY;
>> +	}
>> +}
>> +
>>  static int blkdev_uring_cmd(struct io_uring_cmd *cmd,
>>  			    enum io_uring_cmd_flags flags)
>>  {
>>  	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
>>  
>> +	switch (cmd->op) {
>> +	case BLOCK_URING_OP_IOCTL:
>> +		return blkdev_uring_ioctl(bdev, cmd);
> 
> I don't think the two level dispatch here makes any sense.  Then again

At least it's in my plans to rework it a bit to resolve callbacks in
advance and get rid of double dispatching (for some cases). Like

struct io_cmd {
	void (*cb)(...);
	...
};

struct file_operations {
	struct io_cmd *get_cmd(...);
};

// registration
ctx->cmds[i] = file->get_cmd(...);

And first we do registration, and then use it

> I don't think this code makes sense either except as an example..

-- 
Pavel Begunkov
