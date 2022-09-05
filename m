Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101725ACE3F
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiIEIpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 04:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiIEIpf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 04:45:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3455F31DD3
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 01:45:34 -0700 (PDT)
Received: from [192.168.169.80] (unknown [182.2.42.181])
        by gnuweeb.org (Postfix) with ESMTPSA id 34B627E254;
        Mon,  5 Sep 2022 08:45:30 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662367533;
        bh=xk7fpIRjj9yQpmZLnlOf2FvZfg9fnhv24LUBtF/TdQQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Wol/bZuOv45x/h+D1kb+DgNq7+c6/ejYkrIP7catrhidCF80e2ogC7K9CaqbQAUfS
         awUeZMUzP9ieqYyQdG7AEHSsKVs0+NzA4xwxMnlmJFWxi4iwR/vrZwYDQl0iSIXhkV
         b6wXxsmYqbkdUg8vpuP7xIFvXV+mp3qpstKIFdz7RV5aU39wrVpsUyHz8772j/T05W
         +oLqee4tWdZp8xkE7KwaSH5DZVR/pQEjhzssClEn4AaY6Zn/qvy58/LaJhGqhfw16i
         tRt2S1njWFZSQr589uH1d2s++yRgi6b7adGngMltZxUxLwvMU+kc53QbZA5jDIydAr
         xMcLbfjPFV5pw==
Message-ID: <e0d1b929-52f6-8e99-5942-6b6236a77765@gnuweeb.org>
Date:   Mon, 5 Sep 2022 15:45:28 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v1] test/ringbuf-read: Delete `.ringbuf-read.%d`
 before exit
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
References: <20220905070633.187725-1-ammar.faizi@intel.com>
 <CAOG64qOUeGV1ZY8-Lu01+X=a-sGkxgag7tx3g+pQ_gF8=BGjKQ@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <CAOG64qOUeGV1ZY8-Lu01+X=a-sGkxgag7tx3g+pQ_gF8=BGjKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 3:42 PM, Alviro Iskandar Setiawan wrote:
> On Mon, Sep 5, 2022 at 2:12 PM Ammar Faizi wrote:
>>          fd = open(fname, O_WRONLY);
>>          if (fd < 0) {
>>                  perror("open");
>> -               goto err;
>> +               ret = 1;
>> +               goto out;
>>          }
>>          for (i = 0; i < NR_BUFS; i++) {
>>                  memset(buf, i + 1, BUF_SIZE);
>>                  ret = write(fd, buf, BUF_SIZE);
>>                  if (ret != BUF_SIZE) {
>>                          fprintf(stderr, "bad file prep write\n");
>> -                       goto err;
>> +                       ret = 1;
>> +                       close(fd);
>> +                       goto out;
>>                  }
>>          }
> 
> should use T_EXIT_* for ret?

Yes, we should. I forgot, will send a v2.

-- 
Ammar Faizi
