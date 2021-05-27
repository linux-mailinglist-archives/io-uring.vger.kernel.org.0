Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83739389B
	for <lists+io-uring@lfdr.de>; Fri, 28 May 2021 00:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhE0WQE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 18:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhE0WQE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 18:16:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F768C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:14:30 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n2so1397823wrm.0
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QpMa8N1CrsMoLXhCnjyLgiknkW1ExK55E/epiU8fJ2Y=;
        b=Vy+39f3FWYHvpT7rwfsnXe7HlMMaS8f5zAYNMmNb0wMmfkysZWnJDeFAnk9jItzcBR
         QQGAWoE89BTeY5IuEkJjtv8RhtEXCc7UL7iRMIeepk7uY4M8A16UdnUrRisv62fDlVJJ
         w4szsnoe6Q6iyRilCmjKklj4fCCZZBknIx/zvqdm8AFYnxxqOEhxT+57lu4RNFklUIBQ
         fIeMwqDAVby2LASPjMdYtqtwssDKwUuu0s2auSQREZjEqoBq84Qi1AazpBjT1GtK8Ol2
         zMHQf6GQrIVMfDyyRViKvju2Yyajqd9f9Q1DiF2TJY200wBfmP/P8cOnclDnNVs4EMm+
         a/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpMa8N1CrsMoLXhCnjyLgiknkW1ExK55E/epiU8fJ2Y=;
        b=LhmiOVN18ZuPJVQkSH9kUJraDRDU+I+bnu+Hx6oqBcGh4VZiCeTYTUh0g74Pd2bcJX
         gN2vAO7QahquTQY90xd/KPBcxrfDzpf9WCAng5ZaALmsHoTieo9qrtmlY9kVxXu/dfYM
         uzlz4CdWbbL0fzPq/aGykVKXxbCoFlW76QOQA0hDB9fVKYCqVeVqf1O5vpTuHIoJqhCi
         uyrlNWdbOZvKhi7JhkXDE+k7TUdA3PMyTV+tKMFHIPlR+fHJKn0HC4aAn6xqR+Fpex+L
         hN9MC0FQdKU5hmTXHhOhpex6Z46Wd09XZdoEf3ZM0NUEfkv4+p+W4ZcCEroYISWXLfMk
         8Lxw==
X-Gm-Message-State: AOAM533PNJBf4/w6JFocCaJkp9upuo1Yo5gmehfh6xqqIGUh2217knns
        dzpsCSBf0Y6hWLhu4W1sgavIv848Pg+zmGOc
X-Google-Smtp-Source: ABdhPJzooGmfmZdv9tCoFMg3pDttjnLtuv1MphUTgqmAAEG1kywSq+JVLg2j+ireClzoipkWUBck4w==
X-Received: by 2002:a05:6000:551:: with SMTP id b17mr5426750wrf.32.1622153668609;
        Thu, 27 May 2021 15:14:28 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id o129sm12339686wmo.22.2021.05.27.15.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 15:14:28 -0700 (PDT)
Subject: Re: [PATCH 10/13] io_uring: add helpers for 2 level table alloc
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
References: <cover.1621899872.git.asml.silence@gmail.com>
 <5290fc671b3f5db3ff2a20e2242dd39eba01ec1d.1621899872.git.asml.silence@gmail.com>
 <CAFUsyfL-QOT8tRUNz6Ch5i4pFoB=wMxFemk5CSfWdLHCeRMq5A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a4298a99-4cd7-d204-bec9-b38cc14386e9@gmail.com>
Date:   Thu, 27 May 2021 23:14:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFUsyfL-QOT8tRUNz6Ch5i4pFoB=wMxFemk5CSfWdLHCeRMq5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 10:43 PM, Noah Goldstein wrote:
> On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> -static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
>> +static void io_free_page_table(void **table, size_t size)
>>  {
>> -       unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
>> +       unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
>>
>>         for (i = 0; i < nr_tables; i++)
>> -               kfree(table->files[i]);
>> -       kfree(table->files);
>> -       table->files = NULL;
>> +               kfree(table[i]);
>> +       kfree(table);
>> +}
>> +
>> +static void **io_alloc_page_table(size_t size)
>> +{
>> +       unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
>> +       size_t init_size = size;
>> +       void **table;
>> +
>> +       table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
>> +       if (!table)
>> +               return NULL;
>> +
>> +       for (i = 0; i < nr_tables; i++) {
>> +               unsigned int this_size = min(size, PAGE_SIZE);
>> +
>> +               table[i] = kzalloc(this_size, GFP_KERNEL);
>> +               if (!table[i]) {
>> +                       io_free_page_table(table, init_size);
>> +                       return NULL;
> Unless zalloc returns non-NULL for size == 0, you are guranteed to do
> this for size <= PAGE_SIZE * (nr_tables - 1).  Possibly worth calculating early?

Far from being a fast path, so would rather keep it simpler
and cleaner

> 
> If you calculate early you could then make the loop:
> 
> for (i = 0; i < nr_tables - 1; i++) {
>     table[i] = kzalloc(PAGE_SIZE, GFP_KERNEL);
>     if (!table[i]) {
>         io_free_page_table(table, init_size);
>         return NULL;
>     }
> }
> 
> table[i] = kzalloc(size - (nr_tables - 1) * PAGE_SIZE, GFP_KERNEL);
>     if (!table[i]) {
>         io_free_page_table(table, init_size);
>         return NULL;
>     }
> 
> Which is almost certainly faster.

-- 
Pavel Begunkov
